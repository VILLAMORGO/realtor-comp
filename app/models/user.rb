class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_update :send_approval_email, if: :saved_change_to_approved?

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
    UserMailer.approval_email(self).deliver_later
  end
end
