class RenameLastDelColumn < ActiveRecord::Migration
  def change
    rename_column :orders, :last_develiry_date, :last_delivery_date
  end
end
