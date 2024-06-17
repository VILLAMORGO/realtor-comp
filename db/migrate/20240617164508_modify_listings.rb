class ModifyListings < ActiveRecord::Migration[7.1]
  def change
    remove_column :listings, :title, :string
    remove_column :listings, :description, :text
    remove_column :listings, :price, :decimal

    add_column :listings, :listing_mls_number, :string
    add_column :listings, :listing_amount, :decimal, precision: 10, scale: 2
    add_column :listings, :listing_agent, :integer
    add_column :listings, :commission_split, :decimal, precision: 5, scale: 2
  end
end