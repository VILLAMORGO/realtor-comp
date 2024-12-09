class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_subscription, unless: :devise_controller?
  before_action :set_current_user, if: :user_signed_in?
  before_action :notify_trial_expiration, if: :user_signed_in?

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
    controller_name == "subscriptions" && ["new", "create_checkout_session"].include?(action_name)
  end

  def notify_trial_expiration
    return unless current_user.subscription_status == "trial" && current_user.trial_ends_at.present?
  
    time_left = current_user.trial_ends_at - Time.current
  
    # Define messages based on time_left
    message = case time_left
              when 1.hour then "Your trial period is about to expire in less than an hour. Please consider subscribing to continue using the service."
              when 1.day then "Your trial period is about to expire in 1 day. Please consider subscribing to continue using the service."
              when 7.days then "Your trial period is about to expire in 7 days. Please consider subscribing to continue using the service."
              else return # Exit the method if no match
              end
  
    flash.now[:notice] = message unless on_subscription_page?
  end
end