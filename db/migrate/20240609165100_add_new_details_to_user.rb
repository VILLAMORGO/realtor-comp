class AddNewDetailsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :realtor_license_number, :string
    add_column :users, :broker_first_name, :string
    add_column :users, :broker_last_name, :string
    add_column :users, :broker_email, :string
    add_column :users, :broker_phone_number, :string
  end
end
