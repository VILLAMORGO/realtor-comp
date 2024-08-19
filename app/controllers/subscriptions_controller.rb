class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = current_user.subscriptions.ransack(params[:q])
    @subscriptions = @q.result.paginate(page: params[:page], per_page: 10) # Example with pagination
  end
  
  
  def new
    @plans = [
      { id: 'monthly_plan_id', name: 'Monthly Plan', price: 15 },
      { id: 'annual_plan_id', name: 'Annual Plan', price: 100 }
    ]
  end

  def create_checkout_session
    plan_id = params[:plan_id]

    monthly_price_id = Rails.application.credentials.subscription_monthly_price_id
    annually_price_id = Rails.application.credentials.subscription_annually_price_id

    price_id = plan_id == 'monthly_plan_id' ? monthly_price_id : annually_price_id # Use the correct Stripe price IDs here

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer_email: current_user.email,
      line_items: [{
        price: price_id,
        quantity: 1
      }],
      mode: 'subscription',
      success_url: "#{root_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: root_url
    )

    respond_to do |format|
      format.json { render json: { id: session.id } }
    end
  rescue => e
    Rails.logger.error "Error creating Stripe checkout session: #{e.message}"
    render json: { error: 'Unable to create checkout session' }, status: 400
  end
end