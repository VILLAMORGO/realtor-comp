class AddSubscriptionFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :subscription_plan, :string
    add_column :users, :stripe_customer_id, :string
    add_column :users, :subscription_id, :string
    add_column :users, :subscription_status, :string, default: 'inactive'
  end
end