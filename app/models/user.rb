class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :listings, dependent: :destroy
  
  after_update :send_approval_email, if: :status_changed_to_approved?

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
  validates :mls_number, numericality: { only_integer: true }, allow_blank: true

  enum role: [:agent, :broker, :admin]

  validates :state, presence: true
  STATUS = ["Pending", "Declined", "Approved"]

  def confirmed?
    true
  end

  def admin?
    self.role == 'admin'
  end

  def agent?
    self.role == 'agent'
  end

  def broker?
    self.role == 'broker'
  end

  private

  def send_approval_email
    Rails.logger.debug "Send approval email called for user: #{self.id}"
    UserMailer.with(user: self).approval_email.deliver_later
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def status_changed_to_approved?
    change = saved_change_to_status?
    Rails.logger.debug "Status change detected for user: #{self.id} - #{change}"
    change && status == "Approved"
  end
end
