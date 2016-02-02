class OrderMailer < ActionMailer::Base
  default from: "sales@buyhairillusion.com"

  def receipt(order, total_price)
    @order = order
    @total_price = total_price
    @shipping_cost = order.shipping_cost
    mail(to: @order.orderer.email, subject: 'Hair Illusion Order')
  end
  
  def error_generated(errors,order_id)
    order = Order.find order_id
    mail(to: ["kumar234557@gmail.com"], subject: '#{errors}')    
  end
  
  def order_receipt(order_id) 
    @order = Order.find order_id
    if @order
      @total_price = @order.total_price
      @shipping_cost = @order.get_shipping_cost
    end 
    mail(to: @order.orderer.email, subject: 'Hair Illusion Order') 
  end
  
  def admin_notification(order_id) 
    @order = Order.find order_id
    if @order
      @total_price = @order.total_price
      @shipping_cost = @order.get_shipping_cost
    end 
    mail(to: ["kumar234557@gmail.com","ronpass13@gmail.com"], subject: "New order generated from #{@order.host}") 
  end
  
  def send_notification(order, total_price)
    @order = order
    @total_price = total_price
    @shipping_cost = order.shipping_cost
    mail(to: 'ronpass13@gmail.com', subject: 'Hair Illusion Distributor Order recieved')
  end

  def shipped(order)
    @order = order
    mail(to: @order.orderer.email, subject: 'Hair Illusion Order Shipped')
  end
   
  def send_order_email(distributor_id, order_id)  
    @order = Order.find order_id
    @distributor = DomainDistributor.where(:id=>distributor_id).first
    emails = "#{@distributor.email},kumar234557@gmail.com"
    if @distributor.domain == "hairillusionllc.com"
      emails += ",seorick1904@gmail.com" 
    end
    mail(to: emails, subject: "New Order created from your domain-#{@distributor.domain}") 
  end
  
  def send_forum_email(forum_details) 
    @forum_details = forum_details 
    mail(to: "ronpass13@gmail.com", subject: "New forum posted", from:"forum posted")
  end 
  
end
