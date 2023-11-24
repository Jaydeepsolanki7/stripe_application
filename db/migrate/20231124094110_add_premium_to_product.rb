class AddPremiumToProduct < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :premium, :boolean
  end
end
