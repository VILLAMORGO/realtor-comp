StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed' do |event|
    session = event.data.object
    handle_checkout_session_completed(session)
  end
end

private

def handle_checkout_session_completed(session)
  customer = Stripe::Customer.retrieve(session['customer'])
  user = User.find_by(email: customer.email)

  if user
    user.update(
      subscription_plan: session['display_items'].first['price']['product'],
      stripe_customer_id: customer.id,
      subscription_id: session['subscription'],
      subscription_status: 'active'
    )
    Rails.logger.info "User #{user.email} updated with subscription details."
  else
    Rails.logger.error "User with email #{customer.email} not found."
  end
rescue Stripe::StripeError => e
  Rails.logger.error "Stripe error: #{e.message}"
end