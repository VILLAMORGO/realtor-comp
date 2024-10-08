class Listing < ApplicationRecord
  belongs_to :user

  validates :listing_mls_number, presence: true
  # validates :commission_split, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :commission_type, presence: true, inclusion: { in: %w(percentage fixed), message: "%{value} is not a valid commission type" }
  validates :notes, length: { maximum: 500 }, allow_blank: true
  validates :listing_commission_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # validate :commission_split_within_valid_range

  # Scopes for active and inactive listings
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def self.ransackable_attributes(auth_object = nil)
    ["commission_split", "commission_type", "created_at", "id", "listing_commission_amount", "listing_mls_number", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  private

  # def commission_split_within_valid_range
  #   if commission_type == 'fixed' && commission_split > listing_commission_amount
  #     errors.add(:commission_split, "cannot be greater than the listing commission amount")
  #   elsif commission_type == 'percentage' && commission_split > 100
  #     errors.add(:commission_split, "cannot be greater than 100%")
  #   end
  # end
end