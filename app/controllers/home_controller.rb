class HomeController < ApplicationController
  protect_from_forgery :except => [:thankyou]
   
  def index      



    #session[:order_id] = nil
    #session[:card] = nil
    session[:cart] = nil
    @orderer = Customer.new
    @order = @orderer.orders.build(order_items_attributes: [quantity: 1])
    @credit_card = CreditCard.new
    @distributor = Distributor.new     
    session[:product_cart] = nil
    test_shipwire
  end
  def test_shipwire
    @order = Order.find(4822)
    @order.do_fulfillment
  end
  def clear_all
    session[:product_cart] = nil
  end
  
  def faq
  end

  def photos
  end

  def what_is_it
  end

  def how_it_works
  end

  def about_us
  end

  def color
  end

  def contact_us
  end

  def mens_hair_loss
  end

  def womens_hair_loss
  end

  def thankyou 
  end
  
  def buy_now
    session[:cart] = nil
  end
  
  def after_payment
    redirect_to thank_you_path
  end
  
  def forum 
    @forums = Forum.where(:approved=>true, :domain_name=>"hairillusion.com")#.paginate(per_page: 2, page: params[:page])  
  end
  
  def get_forums
    @forums = []
    if params[:search][:country].blank? && params[:order][:state].blank? 
      @forums = []#.paginate(per_page: 2, page: params[:page])
    elsif params[:search][:country].blank?
      @forums = Forum.where(:domain_name=>"hairillusion.net",:approved=>true, :state=>params[:order][:state])#.paginate(per_page: 2, page: params[:page])
    elsif params[:order][:state].blank?  
      @forums = Forum.where(:domain_name=>"hairillusion.net",:approved=>true, :country=>params[:search][:country]).paginate(per_page: 2, page: params[:page])#.paginate(per_page: 2, page: params[:page])
    else
      @forums = Forum.where(:domain_name=>"hairillusion.net",:approved=>true, :country=>params[:search][:country], :state=>params[:order][:state])#.paginate(per_page: 2, page: params[:page])
    end
  end
  def new_forum
    @forum = Forum.new
  end
  
  def save_forum
    @forum = Forum.new(admin_forum_params)
    @forum.state = params[:order][:state]
    @forum.domain_name = "hairillusion.net"
    if @forum.save 
      @forum.update_attribute(:approved,false) 
     # OrderMailer.send_forum_email(@forum.content).deliver!
      @forums = Forum.where(:approved=>true) 
      redirect_to forum_path, notice: 'Your forum request is successfully submitted.'
    else 
      render action: 'new_forum'
    end 
  end
  
  def get_states  
  end
  
  def add_to_cart 
    @url = 'http://hair-illusion-llc.myshopify.com/cart/'
    session[:cart] = Array.new if session[:cart].nil? 
    position = nil
    if session[:cart].size > 0  
      session[:cart].each_with_index do |d,index|
        if d[:name] == params[:product]
          position = index   
        end
      end
      unless position.nil?
        session[:cart][position][:quantity] = session[:cart][position][:quantity].to_i + params[:quantity].to_i
        if params[:product_type] == "upsell"
          session[:cart][position][:price] = session[:cart][position][:price].to_f + (19.95 * params[:quantity].to_i)
        else
          session[:cart][position][:price] = session[:cart][position][:price].to_f + (params[:unit_price].to_f * params[:quantity].to_i)
        end 
      else
        if params[:product_type] == "upsell"
        h = {:product_type =>params[:product_type], :name => params[:product], :product_id => params[:upsell_id], :quantity => params[:quantity], :price=> (19.95*params[:upsell_qty].to_i)}           
        else
        h = {:name => params[:product], :product_id => params[:product_id], :quantity => params[:quantity], :price=> (params[:unit_price].to_f*params[:quantity].to_i)}           
        end
        session[:cart] << h
      end
    else
      if params[:product_type] == "upsell"
        h = {:product_type =>params[:product_type], :name => params[:product], :product_id => params[:upsell_id], :quantity => params[:quantity], :price=> (19.95*params[:upsell_qty].to_i)}           
      else
        h = {:name => params[:product], :product_id => params[:product_id], :quantity => params[:quantity], :price=> (params[:unit_price].to_f*params[:quantity].to_i)}           
      end
      session[:cart] << h
    end
    str = ""
    session[:cart].each do |d|
      str = str + "," if str.length > 0
      str = str + d[:product_id].to_s + ":"+d[:quantity].to_s
    end
    @url = @url + str + "?source_app=shopify-widget?referer="+params[:referel]
  end
  
  def remove_from_cart
    @url = 'http://hair-illusion-llc.myshopify.com/cart/'
    if session[:cart].size > 0
      session[:cart] = session[:cart].reject { |h| h[:name] == params[:product]  } 
    end
    
    if session[:cart].size > 0
      str = ""
      session[:cart].each do |d|
        str = str + "," if str.length > 0
        str = str + d[:product_id].to_s + ":"+d[:quantity].to_s
      end
      @url = @url + str + "?source_app=shopify-widget?referer="+params[:referel]
    end
  end
  
  def add_product_to_cart
    if session[:product_cart].nil?
      session[:product_cart] = Hash.new
      session[:product_cart][:type] = params[:type] 
      if params[:type].to_s == "recurrent"  
        session[:product_cart][:name] = params[:val] + " - HAIR ILLUSION – FREE SHIPPING + BONUS HAIRLINE OPTIMIZER"
        session[:product_cart][:price] = 29.95
        session[:product_cart][:tax] = 0
        session[:product_cart][:total] = 29.95
      else
        session[:product_cart][:products] = []
        if params[:jet_black].to_i > 0
          h = {:name => "Jet Black", :quantity => params[:jet_black].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end
        
        if params[:black].to_i > 0
          h = {:name => "Black", :quantity => params[:black].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end
        
        if params[:dark_brown].to_i > 0
          h = {:name => "Dark Brown", :quantity => params[:dark_brown].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end
        
        if params[:brown].to_i > 0
          h = {:name => "Brown", :quantity => params[:brown].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end
        
        if params[:light_brown].to_i > 0
          h = {:name => "Light Brown", :quantity => params[:light_brown].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end
        
        if params[:aubrown].to_i > 0
          h = {:name => "Auburn", :quantity => params[:aubrown].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end
        
        if params[:blonde].to_i > 0
          h = {:name => "Blonde", :quantity => params[:blonde].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end
        
        if params[:light_blonde].to_i > 0
          h = {:name => "Light Blonde", :quantity => params[:light_blonde].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end
        
      end
    else
      session[:product_cart][:type] = params[:type]
      if params[:type] == "recurrent"
        session[:product_cart][:product_type] = params[:type]
        session[:product_cart][:name] = params[:val] + " - HAIR ILLUSION – FREE SHIPPING + BONUS HAIRLINE OPTIMIZER"
        session[:product_cart][:product_name] = params[:val]
        session[:product_cart][:price] = 29.95
        session[:product_cart][:tax] = 29.95
      else
        session[:product_cart][:products] = []
        if params[:jet_black].to_i > 0
          h = {:name => "Jet Black", :quantity => params[:jet_black].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end
        
        if params[:black].to_i > 0
          h = {:name => "Black", :quantity => params[:black].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end
        
        if params[:dark_brown].to_i > 0
          h = {:name => "Dark Brown", :quantity => params[:dark_brown].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end
        
        if params[:brown].to_i > 0
          h = {:name => "Brown", :quantity => params[:brown].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end
        
        if params[:light_brown].to_i > 0
          h = {:name => "Light Brown", :quantity => params[:light_brown].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end
        
        if params[:aubrown].to_i > 0
          h = {:name => "Auburn", :quantity => params[:aubrown].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end
        
        if params[:blonde].to_i > 0
          h = {:name => "Blonde", :quantity => params[:blonde].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end
        
        if params[:light_blonde].to_i > 0
          h = {:name => "Light Blonde", :quantity => params[:light_blonde].to_i, :price=> @price, :tax => 6.95 }           
          session[:product_cart][:products] << h
        end        
      end   
    end     
  end
 
 private  
  def admin_forum_params
    params.require(:forum).permit(:subject, :content, :approved, :country, :state, :address, :name)
  end 
  
end
