class AddDetailsToSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :subscriptions, :status, :string
    add_column :subscriptions, :price, :decimal
    add_column :subscriptions, :next_billing_date, :datetime
  end
end