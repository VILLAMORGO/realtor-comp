class Listing < ApplicationRecord
  belongs_to :user

  validates :listing_amount, presence: true, numericality: { greater_than: 0 }
  validates :listing_agent, presence: true
  validates :commission_split, presence: true, numericality: { greater_than_or_equal_to: 0 }
end