class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.column :subscription_plan, :string
      t.column :stripe_customer_id, :string
      t.column :subscription_id, :string
      t.column :subscription_status, :string, default: 'inactive'

      t.timestamps
    end
  end
end
