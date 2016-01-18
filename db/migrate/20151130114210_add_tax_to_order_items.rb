class AddTaxToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :tax, :float
  end
end
