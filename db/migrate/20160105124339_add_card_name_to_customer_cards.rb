class AddCardNameToCustomerCards < ActiveRecord::Migration
  def change
    add_column :customer_cards, :card_name, :text
  end
end
