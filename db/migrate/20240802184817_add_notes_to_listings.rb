class AddNotesToListings < ActiveRecord::Migration[7.1]
  def change
    add_column :listings, :notes, :string, limit: 500
  end
end