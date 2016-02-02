class OrdersController < ApplicationController
  def new
    @orderer = Customer.new
    @order = @orderer.orders.build(order_items_attributes: [quantity: 1])
    @credit_card = CreditCard.new
  end
  
  def create_agent_order
    session[:order_id] = nil
    @errors = []
    cc = nil
    @err_string = ""
    if session[:product_cart]
      unless params[:email].blank?
        @orderer = Customer.where(:email=>params[:email]).first
        if @orderer
          @orderer.first_name = params[:first_name]
          @orderer.first_name = params[:last_name]
          @orderer.email = params[:email]
          @orderer.address1 = params[:address1]
          @orderer.address2 = params[:address2]
          @orderer.city = params[:city]
          @orderer.state = params[:order_state]
          @orderer.country = params[:cb_country]
          @orderer.zip = params[:zip]
          if @orderer.valid?
            @orderer.save
          else
            @error = @orderer.errors
          end
        else
          @orderer = Customer.new(:first_name=>params[:first_name],:last_name=>params[:last_name],:email=>params[:email], :address1=>params[:address1],
          :address2=>params[:address2],:city=>params[:city], :state=>params[:order_state], :country=>params[:cb_country], :zip=>params[:zip])
          
          if @orderer.valid?
            @orderer.save
          else 
            @errors = @orderer.errors.full_messages 
            @errors.each do |p| 
              @err_string = @err_string + p.to_s + "," 
            end  
          end
        end
      end
      @processed = false
      @credit_card = CreditCard.new(:name=>"#{params[:first_name]} #{params[:last_name]}", :number=>params[:card_number], :cvc=>params[:cvv],:exp_month=>params[:month],:exp_year=>params[:exp_year])
      
      unless @credit_card.valid?  
        @errors = @credit_card.errors.messages 
        @errors.each do |p|  
          @err_string = @err_string + p[1][0] + "," 
        end  
      end    
       
      if (@errors.nil? || @errors.empty? || @errors == "") && @credit_card.valid?   
        begin 
          if @orderer.stripe_id.blank? 
            stripe_customer = Stripe::Customer.create(email: @orderer.email) 
            @orderer.stripe_id = stripe_customer.id
            @orderer.save
            if session[:product_cart][:type] == "recurrent"  
              #its free for first time
               unit_price = 0
            end 
          end   
          total_price = 0 
          product = nil
          if session[:product_cart]
            if session[:product_cart][:type] == "recurrent" 
              #update here kk
              product = Product.where(:description=>session[:product_cart][:name],:product_type=>'recurrent').first
              if product  
                total_price = 0
              end  
            else
              if session[:product_cart][:products]
                session[:product_cart][:products].each do |p|  
                  price = ( p[:quantity].to_f * p[:price].to_f ) + ( p[:quantity].to_f * p[:tax].to_f ) 
                  total_price = total_price + price 
                end 
              end
            end
          end   
           
          #only p&h fee for recurrent plan 
          total_price = 8.95*100 if session[:product_cart][:type] == "recurrent" 
          if total_price > 0
            if session[:product_cart][:type] == "recurrent"  
              @order = Order.new(:orderer_id=>@orderer.id, :orderer_type=>"Customer", :order_type=>"recurrent",:first_delivery_date=>Date.today+30.days)  
            else
              @order = Order.new(:orderer_id=>@orderer.id, :orderer_type=>"Customer", :order_type=>"normal")          
            end 
            #set price to stripe
            total_price = total_price
            charge = Stripe::Charge.create(
               #customer: @orderer.stripe_id,
              amount: total_price.to_i,
              description: session[:product_cart][:type],
              currency: 'usd',
              card: { name: @orderer.name, number:params[:card_number], cvc:params[:cvv], exp_month:params[:month], exp_year:params[:exp_year]}
            ) 
            @order.stripe_id = charge.id 
            @orderer.save!
            @order.host = params[:referrer]
            @order.save   
            if session[:product_cart][:type] == "recurrent"  
              cc = CustomerCard.new(:card_number=>params[:card_number], :ccv=>params[:cvv], :exp_month=>params[:month], :exp_year=>params[:exp_year], :customer_id=>@orderer.id)
              cc.save     
              order_item = OrderItem.new(:order_id=>@order.id,:tax=>895, :product_id=>product.id,:quantity=>1, :price=>0) 
              order_item.save(:validate=>false)  
              
              #get free optimizer
              optimizer = Product.where(:description=>"Optimizer").first
              order_item = OrderItem.new(:order_id=>@order.id,:tax=>session[:product_cart][:tax].to_f*100, :product_id=>optimizer.id,:quantity=>1, :price=>0)
              order_item.save 
               
            else  
              @processed = true  
              if session[:product_cart]
                if session[:product_cart][:products]
                  session[:product_cart][:products].each do |p|   
                    product = Product.where("product_type = 'normal'").where(:description=>p[:name]).first 
                    order_item = OrderItem.new(:order_id=>@order.id,:tax=>p[:tax].to_f*100, :product_id=>product.id,:quantity=>p[:quantity], :price=>p[:price].to_f*100)
                    order_item.save
                  end 
                end
              end    
            end
            session[:order_id] = @order.id
            render "thank_you"
          end
          
        rescue Stripe::CardError => e 
          # Since it's a decline, Stripe::CardError will be caught
          body = e.json_body
          err  = body[:error]
          @error = err
          logger.info @error.inspect
          @credit_card.destroy if @credit_card
          puts "Status is: #{e.http_status}"
          puts "Type is: #{err[:type]}"
          puts "Code is: #{err[:code]}"
          # param is '' in this case
          puts "Param is: #{err[:param]}"
          puts "Message is: #{err[:message]}" 
          flash[:alert] = err[:message] 
          @err_string = err[:message] 
          end 
        end  
      end    
  end
  
  def create_order  
    session[:order_id] = nil
    @errors = []
    @err_string = ""
    if session[:product_cart]
      unless params[:email].blank?
        @orderer = Customer.where(:email=>params[:email]).first
        if @orderer
          @orderer.first_name = params[:first_name]
          @orderer.first_name = params[:last_name]
          @orderer.email = params[:email]
          @orderer.address1 = params[:address1]
          @orderer.address2 = params[:address2]
          @orderer.city = params[:city]
          @orderer.state = params[:order_state]
          @orderer.country = params[:cb_country]
          @orderer.zip = params[:zip]
          if @orderer.valid?
            @orderer.save
          else
            @error = @orderer.errors
          end
        else
          @orderer = Customer.new(:first_name=>params[:first_name],:last_name=>params[:last_name],:email=>params[:email], :address1=>params[:address1],
          :address2=>params[:address2],:city=>params[:city], :state=>params[:order_state], :country=>params[:cb_country], :zip=>params[:zip])
          
          if @orderer.valid?
            @orderer.save
          else 
            @errors = @orderer.errors.full_messages 
            @errors.each do |p| 
              @err_string = @err_string + p.to_s + "," 
            end  
          end
        end
      end
      @processed = false
      @credit_card = CreditCard.new(:name=>"#{params[:first_name]} #{params[:last_name]}", :number=>params[:card_number], :cvc=>params[:cvv],:exp_month=>params[:month],:exp_year=>params[:exp_year])
      
      unless @credit_card.valid?  
        @errors = @credit_card.errors.messages 
        @errors.each do |p|  
          @err_string = @err_string + p[1][0] + "," 
        end  
      end   
       
      if (@errors.nil? || @errors.empty? || @errors == "") && @credit_card.valid?   
        begin 
          if @orderer.stripe_id.blank? 
            stripe_customer = Stripe::Customer.create(email: @orderer.email) 
            @orderer.stripe_id = stripe_customer.id
            @orderer.save
            if session[:product_cart][:type] == "recurrent"  
              #its free for first time
               unit_price = 0
            end 
          end   
          total_price = 0 
          product = nil
          if session[:product_cart]
            if session[:product_cart][:type] == "recurrent" 
              #update here kk
              product = Product.where(:description=>session[:product_cart][:name],:product_type=>'recurrent').first
              if product  
                total_price = 0
              end  
            else
              if session[:product_cart][:products]
                session[:product_cart][:products].each do |p|  
                  price = ( p[:quantity].to_f * p[:price].to_f ) + ( p[:quantity].to_f * p[:tax].to_f ) 
                  total_price = total_price + price 
                end 
              end
            end
          end   
           
          #only p&h fee for recurrent plan 
          total_price = 8.95*100 if session[:product_cart][:type] == "recurrent" 
          if total_price > 0
            if session[:product_cart][:type] == "recurrent"  
              @order = Order.new(:orderer_id=>@orderer.id, :orderer_type=>"Customer", :order_type=>"recurrent",:first_delivery_date=>Date.today+30.days)  
            else
              @order = Order.new(:orderer_id=>@orderer.id, :orderer_type=>"Customer", :order_type=>"normal")          
            end 
            #set price to stripe
            total_price = total_price
            charge = Stripe::Charge.create(
               #customer: @orderer.stripe_id,
              amount: total_price.to_i,
              description: session[:product_cart][:type],
              currency: 'usd',
              card: { name: @orderer.name, number:params[:card_number], cvc:params[:cvv], exp_month:params[:month], exp_year:params[:exp_year]}
            ) 
            @order.stripe_id = charge.id 
            @orderer.save!
            @order.host = request.host  
            @order.save   
            if session[:product_cart][:type] == "recurrent" 
              
              cc = CustomerCard.new(:card_number=>params[:card_number], :ccv=>params[:cvv], :exp_month=>params[:month], :exp_year=>params[:exp_year], :customer_id=>@orderer.id)
              cc.save     
              order_item = OrderItem.new(:order_id=>@order.id,:tax=>895, :product_id=>product.id,:quantity=>1, :price=>0) 
              order_item.save(:validate=>false)  
              
              #get free optimizer
              optimizer = Product.where(:description=>"Optimizer").first
              order_item = OrderItem.new(:order_id=>@order.id,:tax=>session[:product_cart][:tax].to_f*100, :product_id=>optimizer.id,:quantity=>1, :price=>0)
              order_item.save 
               
            else 
              @processed = true  
              if session[:product_cart]
                if session[:product_cart][:products]
                  session[:product_cart][:products].each do |p|   
                    product = Product.where("product_type = 'normal'").where(:description=>p[:name]).first 
                    order_item = OrderItem.new(:order_id=>@order.id,:tax=>p[:tax].to_f*100, :product_id=>product.id,:quantity=>p[:quantity], :price=>p[:price].to_f*100)
                    order_item.save
                  end 
                end
              end    
            end
            session[:order_id] = @order.id
            render "thank_you"
          end
          
        rescue Stripe::CardError => e
          @credit_card.destroy
          # Since it's a decline, Stripe::CardError will be caught
          body = e.json_body
          err  = body[:error]
          @error = err
          cc.destroy if cc
          puts "Status is: #{e.http_status}"
          puts "Type is: #{err[:type]}"
          puts "Code is: #{err[:code]}"
          # param is '' in this case
          puts "Param is: #{err[:param]}"
          puts "Message is: #{err[:message]}" 
          flash[:alert] = err[:message] 
          @err_string = err[:message] 
          end 
        end  
      else
        cc.destroy if cc
      end    
  end
  
  def buy_upsell   
    if session[:order_id]  
      upsell = Product.where(:description=>params[:type]).first  
      if upsell
        order = Order.find session[:order_id]
        if order 
          total_price = upsell.price + 395
          orderer = order.orderer  
          customer_card = CustomerCard.find_by_customer_id orderer.id   
          
          charge = Stripe::Charge.create( 
            amount: total_price.to_i,
            description: upsell.description,
            currency: 'usd',
            card: { name: customer_card.card_name, number:customer_card.card_number, cvc:customer_card.ccv, 
              exp_month:customer_card.exp_month, exp_year:customer_card.exp_year}
          ) 
          order_item = OrderItem.new(:order_id=>order.id,:tax=>3.95.to_f*100, :product_id=>upsell.id,:quantity=>1, :price=>upsell.price.to_f)
          order_item.save
        end 
      end
      
      if params[:number].to_i == 1 
          render "second_upsell" 
      elsif params[:number].to_i == 2 
        if order.order_type == "recurrent"
          OrderMailer.order_receipt(session[:order_id]).deliver! 
          render "final_thanks"
        else
          render "third_upsell"
        end 
      elsif  params[:number].to_i == 3
        OrderMailer.order_receipt(session[:order_id]).deliver! 
        render "final_thanks"
      end
 
    end  
  end
  
  def next_upsell
    @order = Order.find session[:order_id] 
    if params[:type] == "optimizer" 
      OrderMailer.order_receipt(@order).deliver!  
    end  
  end

  def create
     
    customer_order = false
    if order_params[:orderer_id]
      @orderer = Distributor.find(order_params[:orderer_id])
      orderer_valid = true
    else
      @orderer = Customer.new(customer_params)
      orderer_valid = @orderer.valid?
      customer_order = true
    end

    @order = @orderer.orders.build(order_params)
    @order.host = request.host

    original_order_items = []
    @order.order_items.each { |oi| original_order_items<< oi.dup }
    @order.order_items.each { |oi| oi.price = @orderer.try(:price) || oi.product.price }
    @order.order_items = @order.order_items.keep_if { |oi| oi.quantity > 0 }

    @credit_card = CreditCard.new(cc_params)

    order_valid = @order.valid?
    credit_card_valid = @credit_card.valid? 
    
    if customer_order 
      if orderer_valid && order_valid  
        @orderer.stripe_id = Time.now.to_i.to_s
        @order.stripe_id = Time.now.to_i.to_s         
        @orderer.save!
        @order.save! 
        
        redirect_to buy_product_orders_path 
      else
        render new_order_path 
      end  
    else 
    if orderer_valid && order_valid && credit_card_valid
      begin
        #if @orderer.stripe_id.blank?
          stripe_customer = Stripe::Customer.create(card: cc_params, email: @orderer.email) 
          @orderer.stripe_id = stripe_customer.id
       # end

        total_price = @order.total   
        charge = Stripe::Charge.create(
          customer: @orderer.stripe_id,
          amount: total_price,
          description: @order.description,
          currency: 'usd' 
        ) 
        
        @order.stripe_id = charge.id
        @orderer.valid?
        @order.valid? 
        
        @orderer.save!
        @order.save! 
        OrderMailer.send_notification(@order, total_price).deliver!
        
        flash[:notice] = "Thanks for your order"
        redirect_to confirmation_orders_path
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

        flash[:alert] = err[:message]

        if order_params[:orderer_id]
          @order.order_items = original_order_items
          @distributor = @orderer
          render 'distributors/show'
        else
          render new_order_path
        end
      rescue => e
        # Something else happened, completely unrelated to Stripe
        flash[:alert] = e.message
        if order_params[:orderer_id]
          @order.order_items = original_order_items
          @distributor = @orderer
          render 'distributors/show'
        else
          render new_order_path
        end
      end
    else
      if order_params[:orderer_id]
        @order.order_items = original_order_items
        @distributor = @orderer
        render 'distributors/show'
      else
        render new_order_path
      end
    end 
    end
  end
  
  def buy_product 
  end
  
  def confirmation
  end

  private
  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :address1, :address2, :city, :state, :zip, :country)
  end

  def order_params
    params.require(:order).permit(:orderer_id, order_items_attributes: [:product_id, :quantity])
  end

  def cc_params
    params.require(:credit_card).permit(:name, :number, :cvc, :exp_month, :exp_year)
  end
end
