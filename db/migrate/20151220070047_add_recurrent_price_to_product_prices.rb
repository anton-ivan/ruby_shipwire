class AddRecurrentPriceToProductPrices < ActiveRecord::Migration
  def change
    add_column :product_prices, :recurrent_price, :float
  end
end
