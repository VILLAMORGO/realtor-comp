class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :listings, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  has_one_attached :profile_picture

  # after_update :send_activated_email, if: :status_changed_to_approved?

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
  validates :mls_number, numericality: { only_integer: true }, allow_blank: true

  validate :password_lower_case, if: -> { password.present? && should_validate_password? }
  validate :password_uppercase, if: -> { password.present? && should_validate_password? }
  validate :password_special_char, if: -> { password.present? && should_validate_password? }
  validate :password_contains_number, if: -> { password.present? && should_validate_password? }
  validates :password, length: { minimum: 8, message: 'must be at least 8 characters long' }, if: -> { password.present? && should_validate_password? }

  validates :state, presence: true
  STATUS = ["Pending", "Declined", "Approved"]

  enum role: [:agent, :broker, :admin]

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

  def password_uppercase
    return if password.match(/\p{Upper}/)
    errors.add :password, ' At least 1 uppercase '
  end

  def password_lower_case
    return if password.match(/\p{Lower}/)
    errors.add :password, ' At least 1 lowercase '
  end

  def password_special_char
    special = "?<>',?[]}{=-)(*&^%$#`~{}!"
    regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
    return if password =~ regex
    errors.add :password, ' At least one special character'
  end

  def password_contains_number
    return if password.count("0-9") > 0
    errors.add :password, ' At least one number'
  end

  private

  def should_validate_password?
    new_record? || (password.present? && encrypted_password.blank?)
  end  

  # def send_activated_email
  #   Rails.logger.debug "Send approval email called for user: #{id}"
  #   UserMailer.with(user: self).admin_approval_email.deliver_later
  # end

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