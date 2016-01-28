namespace :hair do
  
  task :add_sku => :environment do
     p = Product.where(:description=>"Jet Black").first
     p.update_attribute(:sku,"123")
      
     p = Product.where(:description=>"Black").first
     p.update_attribute(:sku,"111")
     
     p = Product.where(:description=>"Dark Brown").first
     p.update_attribute(:sku,"222")           

     p = Product.where(:description=>"Brown").first
     p.update_attribute(:sku,"333")
                 
     p = Product.where(:description=>"Light Brown").first
     p.update_attribute(:sku,"444")

     p = Product.where(:description=>"Auburn").first
     p.update_attribute(:sku,"555")

     p = Product.where(:description=>"Blonde").first
     p.update_attribute(:sku,"555")

     p = Product.where(:description=>"Light Blonde").first
     p.update_attribute(:sku,"666")

     p = Product.where(:description=>"Hair Illusion Fiber Hold Spray").first
     p.update_attribute(:sku,"777")

     p = Product.where(:description=>"Mirror").first
     p.update_attribute(:sku,"888")

     p = Product.where(:description=>"Optimizer").first
     p.update_attribute(:sku,"999")
     
  end
   
 
end
