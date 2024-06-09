class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true
  validates :mls_number, numericality: { only_integer: true }, allow_blank: true

  enum role: [:agent, :broker, :admin]

  validates :state, presence: true
  STATUS = ["Pending", "Declined", "Approved"]

  def confirmed?
    true
  end
end
