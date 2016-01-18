class AddMoreFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :order_type, :string
    add_column :orders, :first_delivery_date, :date
    add_column :orders, :next_delivery_date, :date
  end
end
