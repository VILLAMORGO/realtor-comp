class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_subscription, unless: :devise_controller?

  before_action :set_current_user, if: :user_signed_in?

  private

  def set_current_user
    Current.user = current_user
  end

  def check_subscription
    if user_signed_in? && !current_user.subscription_active? && !current_user.admin? && !on_subscription_page?
      redirect_to new_subscription_path, alert: 'You must subscribe to access this page.'
    end
  end

  def on_subscription_page?
    params[:controller] == "subscriptions" && ["new", "create_checkout_session"].include?(params[:action])
  end
end