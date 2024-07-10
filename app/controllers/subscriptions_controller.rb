class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @plans = [
      { id: 'monthly_plan_id', name: 'Monthly Plan', price: 1000 },
      { id: 'annual_plan_id', name: 'Annual Plan', price: 10000 }
    ]
  end

  def create
    plan_id = params[:plan_id]
    begin
      customer = Stripe::Customer.create({
        email: current_user.email,
        source: params[:stripeToken]
      })

      subscription = Stripe::Subscription.create({
        customer: customer.id,
        items: [{ plan: plan_id }]
      })

      current_user.update(
        subscription_plan: plan_id,
        stripe_customer_id: customer.id,
        subscription_id: subscription.id,
        subscription_status: subscription.status
      )

      redirect_to root_path, notice: 'Subscription successful!'
    rescue Stripe::StripeError => e
      flash[:error] = e.message
      render :new
    end
  end
end