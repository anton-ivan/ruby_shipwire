namespace :hair do
  
  task :create_shipwire_orders => :environment do
    normal_orders = Order.where("order_type != 'recurrent' and refunded_at is null and shipment_id is null") 
    puts Shipwire.configure().inspect
    
  end
   
 
end
