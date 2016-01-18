class CreateOrderDeliveries < ActiveRecord::Migration
  def change
    create_table :order_deliveries do |t|
      t.integer :order_id
      t.date :delivered_date

      t.timestamps
    end
  end
end
