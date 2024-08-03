class ModifyListingsForMlsNumberAndAgent < ActiveRecord::Migration[7.1]
  def change
    # Remove the listing_agent column
    remove_column :listings, :listing_agent, :integer

    # Remove the listing_amount column
    remove_column :listings, :listing_amount, :decimal, precision: 10, scale: 2

    # Add the listing_commission_amount column
    add_column :listings, :listing_commission_amount, :decimal, precision: 10, scale: 2
  end
end
