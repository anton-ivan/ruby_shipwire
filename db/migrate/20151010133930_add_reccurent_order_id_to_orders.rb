class AddReccurentOrderIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :recurrent_order_id, :integer
  end
end
