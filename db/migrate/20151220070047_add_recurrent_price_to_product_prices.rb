class AddRecurrentPriceToProductPrices < ActiveRecord::Migration
  def change
    add_column :products, :sku, :float
  end
end
