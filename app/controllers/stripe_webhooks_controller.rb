class StripeWebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    Rails.logger.info "Webhook created successfully"
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.webhook_secret

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      Rails.logger.error "Invalid payload: #{e.message}"
      render json: { error: 'Invalid payload' }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      Rails.logger.error "Invalid signature: #{e.message}"
      render json: { error: 'Invalid signature' }, status: 400
      return
    end

    handle_event(event)

    render json: { message: 'Success' }, status: 200
  end

  private

  def handle_event(event)
    case event['type']
    when 'checkout.session.completed'
      session = event['data']['object']
      handle_checkout_session_completed(session)
      Rails.logger.info "handle_checkout_session_completed(session)."
    when 'invoice.payment_succeeded'
      invoice = event['data']['object']
      handle_invoice_payment_succeeded(invoice)
      Rails.logger.info "handle_invoice_payment_succeeded(invoice)"
    when 'customer.subscription.updated'
      subscription = event['data']['object']
      handle_subscription_updated(subscription)
      Rails.logger.info "handle_subscription_updated(subscription)"
    else
      Rails.logger.warn "Unhandled event type: #{event['type']}"
    end
  end

  def handle_checkout_session_completed(session)
    customer_email = session['customer_email'] || session.dig('customer_details', 'email')
    user = User.find_by_email(customer_email)
  
    if user
      subscription = Stripe::Subscription.retrieve(session['subscription'])
      interval = subscription['items']['data'].first['price']['recurring']['interval']
      subscription_plan = interval == 'month' ? 'monthly' : 'annual'
      status = subscription['status']
      price = subscription['items']['data'].first['price']['unit_amount'] / 100.0
      next_billing_date = Time.at(subscription['current_period_end'])
  
      # Create the subscription record
      user.subscriptions.create(
        subscription_plan: subscription_plan,
        stripe_customer_id: session['customer'],
        subscription_id: subscription['id'],
        status: status,
        price: price,
        next_billing_date: next_billing_date
      )

      #Send mail to customer
      UserMailer.with(user: user).subscribed_email.deliver_now
  
      # Update user's subscription status
      user.update(subscription_status: 'active')
      Rails.logger.info "User #{user.email} updated with stripe_customer_id, subscription_status, subscription_plan, and subscription_id."
    else
      Rails.logger.error "User with email #{customer_email} not found."
    end
  end

  def handle_invoice_payment_succeeded(invoice)
    customer_email = invoice['customer_email']
    user = User.find_by_email(customer_email)

    if user
      Rails.logger.info "Payment succeeded for user #{user.email}."
      user.update(subscription_status: 'active') if user.subscription_status == 'inactive'
    else
      Rails.logger.error "User with email #{customer_email} not found."
    end
  end

  def handle_subscription_updated(subscription)
    customer = Stripe::Customer.retrieve(subscription['customer'])
    user = User.find_by_email(customer.email)
  
    if user
      interval = subscription['items']['data'].first['price']['recurring']['interval']
      subscription_plan = interval == 'month' ? 'monthly' : 'annual'
      status = subscription['status']
      price = subscription['items']['data'].first['price']['unit_amount'] / 100.0
      next_billing_date = Time.at(subscription['current_period_end'])
  
      # Find the subscription record
      user_subscription = user.subscriptions.find_by_subscription_id(subscription['id'])
  
      if user_subscription
        # Update the subscription record
        user_subscription.update(
          subscription_plan: subscription_plan,
          stripe_customer_id: subscription['customer'],
          status: status,
          price: price,
          next_billing_date: next_billing_date
        )

        Rails.logger.info "Subscription updated for user #{user.email}."
      end
  
      # Update user's subscription status
      user.update(subscription_status: subscription['status'])
    else
      Rails.logger.error "User with email #{customer.email} not found."
    end
  end  
end