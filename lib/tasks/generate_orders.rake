namespace :hair do
  
  task :generate_orders => :environment do
    products = Product.all
      products.each do |product|
      #product.price = 4495
      product.update_attribute(:price, 5995)
      product.update_attribute(:weight, 3.3)
      puts product.inspect
      product.save
    end
  end 
   
end
