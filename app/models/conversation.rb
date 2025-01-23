class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants

  # Enable broadcasting for real-time updates
  broadcasts
end