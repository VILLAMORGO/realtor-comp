class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  after_create_commit -> { broadcast_append_to conversation }

  validates :body, presence: true
end