class AddNewDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :street_address, :string
    add_column :users, :home_address, :string
    add_column :users, :city_address, :string
    add_column :users, :zip_code, :string
  end
end
