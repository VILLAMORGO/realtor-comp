class RemoveSubscriptionStatusFromSubscriptions < ActiveRecord::Migration[7.1]
  def change
    remove_column :subscriptions, :subscription_status, :string
  end
end
