class Subscription < ApplicationRecord
  belongs_to :user

  validates :subscription_plan, presence: true
  validates :stripe_customer_id, presence: true
  validates :subscription_id, presence: true
  validates :subscription_plan, presence: true
  validates :stripe_customer_id, presence: true
  validates :subscription_id, presence: true

  def self.check_expired_subscriptions
    subscriptions = where("next_billing_date < ? AND status = ?", Time.current, 'active')
    subscriptions.each do |subscription|
      subscription.update(status: 'expired')
      subscription.user.update(subscription_status: 'inactive')
      UserMailer.with(user: subscription.user).subscription_expired_email.deliver_now
    end
  end
end