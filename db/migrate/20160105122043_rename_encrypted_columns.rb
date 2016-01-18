class RenameEncryptedColumns < ActiveRecord::Migration
  def change
    rename_column :customer_cards, :card_number, :encrypted_card_number
    rename_column :customer_cards, :ccv, :encrypted_ccv
    rename_column :customer_cards, :exp_month, :encrypted_exp_month
    rename_column :customer_cards, :exp_year, :encrypted_exp_year
  end
end
