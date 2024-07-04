class AddCommissionTypeToListings < ActiveRecord::Migration[7.1]
  def change
    add_column :listings, :commission_type, :string
  end
end
