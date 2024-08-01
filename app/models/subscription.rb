class Subscription < ApplicationRecord
  belongs_to :user

  validates :subscription_plan, presence: true
  validates :stripe_customer_id, presence: true
  validates :subscription_id, presence: true
  validates :subscription_status, presence: true
end