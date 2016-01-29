namespace :hair do
  
  task :add_sku => :environment do
     p = Product.where(:description=>"Jet Black").first
     p.update_attribute(:sku,"678021720278")
      
     p = Product.where(:description=>"Black").first
     p.update_attribute(:sku,"678021720292")
     
     p = Product.where(:description=>"Dark Brown").first
     p.update_attribute(:sku,"678021720261")           

     p = Product.where(:description=>"Brown").first
     p.update_attribute(:sku,"678021720285")
                 
     p = Product.where(:description=>"Light Brown").first
     p.update_attribute(:sku,"678021720308")

     p = Product.where(:description=>"Auburn").first
     p.update_attribute(:sku,"678021720315")

     p = Product.where(:description=>"Blonde").first
     p.update_attribute(:sku,"678021720322")

     p = Product.where(:description=>"Light Blonde").first
     p.update_attribute(:sku,"678021720339")

     p = Product.where(:description=>"Hair Illusion Fiber Hold Spray").first
     p.update_attribute(:sku,"678021720353")

     p = Product.where(:description=>"Mirror").first
     p.update_attribute(:sku,"654391270988")

     p = Product.where(:description=>"Optimizer").first
     p.update_attribute(:sku,"788454232344")
     
  end
   
 
end
