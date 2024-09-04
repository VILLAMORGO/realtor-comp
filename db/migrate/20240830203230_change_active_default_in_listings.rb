class ChangeActiveDefaultInListings < ActiveRecord::Migration[7.1]
  def change
    change_column_default :listings, :active, false
  end
end