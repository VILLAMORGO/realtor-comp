class AddActiveToListings < ActiveRecord::Migration[7.1]
  def change
    add_column :listings, :active, :boolean
  end
end