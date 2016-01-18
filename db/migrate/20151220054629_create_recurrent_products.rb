class CreateRecurrentProducts < ActiveRecord::Migration
  def change
    create_table :recurrent_products do |t|
      t.string :product_name
      t.string :subscription_name

      t.timestamps
    end
  end
end
