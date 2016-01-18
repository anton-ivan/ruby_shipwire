namespace :hair do
  
  task :create_upsells => :environment do
       p = Product.new(:description=>"Mirror", :product_code=>3000,:price=>1995,:weight=>10)  
       p.save(:validate=>false)
       
       p = Product.new(:description=>"Optimizer", :product_code=>3000,:price=>1995,:weight=>10) 
       p.save(:validate=>false)
       
  end
 
end
