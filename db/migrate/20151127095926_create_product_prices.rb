class CreateProductPrices < ActiveRecord::Migration
  def change
    create_table :product_prices do |t|
      t.float :price

      t.timestamps
    end
  end
end
