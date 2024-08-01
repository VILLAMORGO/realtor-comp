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
    if current_user.subscription_status == "trial" && current_user.trial_ends_at.present?
      if current_user.trial_ends_at < 1.hour.from_now
        # Only set the flash notice if not on the subscription page
        unless on_subscription_page?
          flash.now[:notice] = "Your trial period is about to expire in less than an hour. Please consider subscribing to continue using the service."
        end
      end
    end
  end
end
