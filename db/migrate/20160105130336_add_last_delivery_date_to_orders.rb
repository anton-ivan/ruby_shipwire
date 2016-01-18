class AddLastDeliveryDateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :last_develiry_date, :date
  end
end
