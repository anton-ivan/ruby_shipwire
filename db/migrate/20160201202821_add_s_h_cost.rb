class AddSHCost < ActiveRecord::Migration
  def change
    add_column :order_items, :s_h_cost, :integer
  end
end
