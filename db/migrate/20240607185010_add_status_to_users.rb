class AddStatusToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :status, :string, null: false, default: 'Pending'
  end
end
