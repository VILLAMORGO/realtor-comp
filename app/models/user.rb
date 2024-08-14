class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :listings, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  has_one_attached :profile_picture

  after_update :send_activated_email, if: :status_changed_to_approved?

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
  validates :mls_number, numericality: { only_integer: true }, allow_blank: true

  enum role: [:agent, :broker, :admin]

  validates :state, presence: true
  STATUS = ["Pending", "Declined", "Approved"]
  

  def admin?
    role == 'admin'
  end

  def agent?
    role == 'agent'
  end

  def broker?
    role == 'broker'
  end

  def subscription_active?
    subscription_status == "active" || (subscription_status == "trial" && trial_ends_at > Time.current)
  end

  def trial_period_active?
    subscription_status == "trial" && trial_ends_at > Time.current
  end

  def subscription_expired?
    !subscription_active?
  end

  def self.ransackable_attributes(auth_object = nil)
    ["first_name", "last_name", "mls_number", "email", "status", "role", "state", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["listings"]
  end

  def extend_trial_period
    if trial_period_active? && trial_ends_at <= 30.days.from_now
      update(trial_ends_at: trial_ends_at + 60.days)
      send_trial_extend_email
    end
  end

  private

  def send_activated_email
    Rails.logger.debug "Send approval email called for user: #{id}"
    UserMailer.with(user: self).activated_email.deliver_later
  end

  def send_trial_extend_email
    Rails.logger.debug "Send extended trial email called for user: #{id}"
    UserMailer.with(user: self).extended_trial_email.deliver_now
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def status_changed_to_approved?
    change = saved_change_to_status?
    Rails.logger.debug "Status change detected for user: #{id} - #{change}"
    change && status == "Approved"
  end
end