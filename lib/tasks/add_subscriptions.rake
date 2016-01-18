namespace :hair do
  
  task :add_subscriptions => :environment do
     p = RecurrentProduct.new(:product_name=>"Jet Black - HAIR ILLUSION – FREE SHIPPING + BONUS HAIRLINE OPTIMIZER",:subscription_name=>'jet_black')
     p.save
      
     p = RecurrentProduct.new(:product_name=>"Black - HAIR ILLUSION – FREE SHIPPING + BONUS HAIRLINE OPTIMIZER",:subscription_name=>'black')
     p.save
     
     p = RecurrentProduct.new(:product_name=>"Dark Brown - HAIR ILLUSION – FREE SHIPPING + BONUS HAIRLINE OPTIMIZER",:subscription_name=>'dark_brown')
     p.save
            
     p = RecurrentProduct.new(:product_name=>"Brown - HAIR ILLUSION – FREE SHIPPING + BONUS HAIRLINE OPTIMIZER",:subscription_name=>'brown')
     p.save
     
     p = RecurrentProduct.new(:product_name=>"Brown - HAIR ILLUSION – FREE SHIPPING + BONUS HAIRLINE OPTIMIZER",:subscription_name=>'brown')
     p.save
     
     p = RecurrentProduct.new(:product_name=>"Light Brown - HAIR ILLUSION – FREE SHIPPING + BONUS HAIRLINE OPTIMIZER",:subscription_name=>'light_brown')
     p.save

     p = RecurrentProduct.new(:product_name=>"Auburn - HAIR ILLUSION – FREE SHIPPING + BONUS HAIRLINE OPTIMIZER",:subscription_name=>'auburn')
     p.save

     p = RecurrentProduct.new(:product_name=>"Blonde - HAIR ILLUSION – FREE SHIPPING + BONUS HAIRLINE OPTIMIZER",:subscription_name=>'blonde')
     p.save

     p = RecurrentProduct.new(:product_name=>"Light Blonde - HAIR ILLUSION – FREE SHIPPING + BONUS HAIRLINE OPTIMIZER",:subscription_name=>'light_blonde')
     p.save
                 
  end
   
 
end
