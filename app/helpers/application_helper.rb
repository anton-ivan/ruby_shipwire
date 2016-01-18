module ApplicationHelper
  def control_group(object, method, params = {}, &block)
    hide_label = params[:hide_label] || false
    label_text = params[:label] || nil

    content_class = "form-group"
    error_content = ''

    if object.errors.include?(method)
      content_class += " has-error"
      error_content = content_tag(:span, object.errors[method][0], :class => 'help-block')
    end unless object.nil?

    content = ''
    content += label(object.class.to_s.downcase, method, label_text, :class => 'col-md-4 control-label') unless hide_label
    content += content_tag(:div, content_tag(:div, capture(&block), :class => 'col-sm-6') + error_content, :class => "controls row")

    content_tag(:div, raw(content), :class => content_class)
  end

  def icon_text(text, icon)
    output = content_tag(:i, nil, :class => icon)
    output += " #{text}" unless text.nil?

    raw output
  end

  ALERT_TYPES = [:danger, :info, :success, :warning]

  def flash_message
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = :success if type == :notice
      type = :danger  if type == :alert
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|

        text = content_tag(:div, content_tag(:div, content_tag(:div,
                           content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                           msg.html_safe, :class => "alert alert-#{type} fade in"), class: 'col-md-12'), class: 'row')
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

  def color_options_for_select(selected = nil)
    options = OrderItem::COLOR.collect { |key, value| [key.to_s.titleize, value] }
    options.unshift(['Select Your Color', nil])

    options_for_select(options, selected)
  end

  def us_state_options_for_select(selected = nil)
    options_for_select([
      [nil, nil],
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Washington DC', 'DC'],
      ['Delaware', 'DE'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ], selected)
  end
  
  def get_country_name(country_id, from_view)
    return "" if country_id.nil?
    country = Carmen::Country.coded(country_id)
    return "" if country.nil?
    country_name = country.name
    country_name = "United Kingdom Great Britain" if country_name == "United Kingdom"
    return "#{country_name}" if from_view == true
    return " , #{country_name}"
  end
  
  def get_commission(dist_orders)
    begin
    price = 0
    distributor_id = 0
    dist_orders.each do |order|
      price = price + order.order.total_commission_price 
    end
    
    if dist_orders.size > 0
      distributor_id = dist_orders.first.distributor_id
      distributor = DomainDistributor.find distributor_id
      percent = distributor.percentage
      price = price * (percent/100.00)
    end 
    return price 
    rescue 
      return 0 
    end
  end
  
  def get_total_sales(dist_orders)
    begin
    price = 0
    distributor_id = 0
    dist_orders.each do |order|
      logger.info order.inspect
      logger.info "logger.info order.inspect--#{order.order.inspect}"
      price = price + order.order.total_price 
    end 
    return price 
    rescue 
      return 0 
    end
  end
  
  def get_state_name(country_id,state_id)
    @country = Carmen::Country.coded(country_id)
    @subregion = @country.subregions.coded(state_id)
    return @subregion.name
  end
  
  def colours_list
    return [['Black','2185852801'],['Jet Black','2185852737'],['Dark Brown','2185852929'],['Brown','2185853057'],['Light Brown','2185853185'],['Auburn','2185853249'],['Blonde','2185853377'],['Light Blonde','2185853441']]
  end
  
  def get_total_amount
    if session[:cart]
      price = 0
      session[:cart].each do |c|
        price = price.to_f + c[:price].to_f
      end
      return number_with_precision(price, :precision => 2)
    else
      return "0.00$"
    end 
  end
  
  def get_sub_total_from_session
    return 0 unless session[:product_cart]
    sub_total = 0 
    session[:product_cart][:products].each do |p|
      sub_total += (p[:price].to_f * p[:quantity].to_f)
    end
    return sub_total
  end
  
  def get_ph_session
    return 0 unless session[:product_cart]
    tax = 0 
    session[:product_cart][:products].each do |p|
      tax += (p[:tax].to_f * p[:quantity].to_f)
    end
    return tax   
  end
  
  def get_total_price_from_session
    return 0 unless session[:product_cart]
    tax = 0 
    session[:product_cart][:products].each do |p|
      tax += ( (p[:tax].to_f * p[:quantity].to_f) + (p[:price].to_f * p[:quantity].to_f))
    end
    return tax   
  end
  
end
