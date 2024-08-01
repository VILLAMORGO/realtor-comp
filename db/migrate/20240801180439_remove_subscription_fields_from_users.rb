class RemoveSubscriptionFieldsFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :subscription_plan, :string
    remove_column :users, :stripe_customer_id, :string
    remove_column :users, :subscription_id, :string
    remove_column :users, :subscription_status, :string
  end
end
