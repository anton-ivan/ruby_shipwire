namespace :hair do
  
  task :add_recurrent_products => :environment do
    
    p = Product.where(:description=>"Jet Black").first
    p.update_attribute(:product_type,"normal")

    p = Product.where(:description=>"Black").first
    p.update_attribute(:product_type,"normal")
    
    p = Product.where(:description=>"Dark Brown").first
    p.update_attribute(:product_type,"normal")
    
    p = Product.where(:description=>"Brown").first
    p.update_attribute(:product_type,"normal")
    

    p = Product.where(:description=>"Light Brown").first
    p.update_attribute(:product_type,"normal")
    

    p = Product.where(:description=>"Auburn").first
    p.update_attribute(:product_type,"normal")   


    p = Product.where(:description=>"Blonde").first
    p.update_attribute(:product_type,"normal")   


    p = Product.where(:description=>"Light Blonde").first
    p.update_attribute(:product_type,"normal")  

    p = Product.where(:description=>"Mirror").first
    p.update_attribute(:product_type,"normal")  
    
    p = Product.where(:description=>"Optimizer").first
    p.update_attribute(:product_type,"normal")  
    p.update_attribute(:price,695)  
    
    p = Product.where(:description=>"Hair Illusion Fiber Hold Spray").first
    p.update_attribute(:product_type,"normal")  
    
              
     p = Product.where(:description=>"Jet Black", :product_type=>"recurrent").first
     if p 
      p.update_attribute(:sku,"713807586669")
     else
       Product.create(:description=>"Jet Black", :product_type=>"recurrent", :price=> 00, :product_code=>2092, :weight=>18, :sku=>"713807586669")
     end
     
     p = Product.where(:description=>"Black", :product_type=>"recurrent").first
     if p 
      p.update_attribute(:sku,"713807586591")
     else
       Product.create(:description=>"Black", :product_type=>"recurrent", :price=> 00, :product_code=>2093, :weight=>18, :sku=>"713807586591")
     end
     
     p = Product.where(:description=>"Dark Brown", :product_type=>"recurrent").first
     if p 
      p.update_attribute(:sku,"713807586621")
     else
       Product.create(:description=>"Dark Brown", :product_type=>"recurrent", :price=> 00, :product_code=>2094, :weight=>18, :sku=>"713807586621")
     end
 
     p = Product.where(:description=>"Brown", :product_type=>"recurrent").first
     if p 
      p.update_attribute(:sku,"713807586607")
     else
       Product.create(:description=>"Brown", :product_type=>"recurrent", :price=> 00, :product_code=>2095, :weight=>18, :sku=>"713807586607")
     end
 
     p = Product.where(:description=>"Light Brown", :product_type=>"recurrent").first
     if p 
      p.update_attribute(:sku,"713807586614")
     else
       Product.create(:description=>"Light Brown", :product_type=>"recurrent", :price=> 00, :product_code=>2096, :weight=>18, :sku=>"713807586614")
     end
     
     p = Product.where(:description=>"Auburn", :product_type=>"recurrent").first
     if p 
      p.update_attribute(:sku,"713807586638")
     else
       Product.create(:description=>"Auburn", :product_type=>"recurrent", :price=> 00, :product_code=>2097, :weight=>18, :sku=>"713807586638")
     end  

     p = Product.where(:description=>"Blonde", :product_type=>"recurrent").first
     if p 
      p.update_attribute(:sku,"713807586645")
     else
       Product.create(:description=>"Blonde", :product_type=>"recurrent", :price=> 00, :product_code=>2098, :weight=>18, :sku=>"713807586645")
     end  

     p = Product.where(:description=>"Light Blonde", :product_type=>"recurrent").first
     if p 
      p.update_attribute(:sku,"713807586652")
     else
       Product.create(:description=>"Light Blonde", :product_type=>"recurrent", :price=> 00, :product_code=>2099, :weight=>18, :sku=>"713807586652")
     end   
  end
   
 
end
