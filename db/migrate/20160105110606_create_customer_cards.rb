class CreateCustomerCards < ActiveRecord::Migration
  def change
    create_table :customer_cards do |t|
      t.integer :customer_id
      t.text :card_number
      t.text :ccv
      t.text :exp_month
      t.text :exp_year

      t.timestamps
    end
  end
end
