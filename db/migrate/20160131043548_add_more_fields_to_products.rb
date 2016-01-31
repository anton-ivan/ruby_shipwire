class AddMoreFieldsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :product_type, :string
  end
end
