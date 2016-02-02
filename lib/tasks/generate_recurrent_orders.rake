namespace :hair do 
  task :generate_recurrent_orders => :environment do
     orders = Order.where("order_type ='recurrent' and next_delivery_date =? and last_delivery_date < ? and cancelled=false", Date.today, Date.today)
     orders.each do |order|
        @orderer = order.customer
        if @orderer.stripe_id.blank? 
            stripe_customer = Stripe::Customer.create(email: @orderer.email) 
            @orderer.stripe_id = stripe_customer.id
            @orderer.save 
          end   
          
          total_price = 0          
          order.order_items.each do |o_i|
            product = Product.find o_i.product_id
            price = product.price
            price = 2995 if price == 0
            total_price = total_price + (price*o_i.quantity) + (895*o_i.quantity)
          end
      begin      
          customer_card = CustomerCard.find_by_customer_id @orderer.id
          if customer_card 
           charge = Stripe::Charge.create( 
              amount: total_price.to_i,
              description: order.id,
              currency: 'usd',
              card: { name: customer_card.card_name, number:customer_card.card_number, cvc:customer_card.ccv, 
              exp_month:customer_card.exp_month, exp_year:customer_card.exp_year}
            ) 
          end
  
      OrderMailer.order_receipt(@order.id).deliver! 
      rescue Stripe::CardError => e  
        # Since it's a decline, Stripe::CardError will be caught
        body = e.json_body
        err  = body[:error]

        puts "Status is: #{e.http_status}"
        puts "Type is: #{err[:type]}"
        puts "Code is: #{err[:code]}"
        # param is '' in this case
        puts "Param is: #{err[:param]}"
        puts "Message is: #{err[:message]}"

        @errors = err[:message]
        OrderMailer.error_generated(@errors,order.id) 
      rescue => e
        # Something else happened, completely unrelated to Stripe
        @errors = e.message 
        OrderMailer.error_generated(@errors,order.id)
      end 
     end
  end 
   
end
