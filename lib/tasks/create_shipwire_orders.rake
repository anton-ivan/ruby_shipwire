require 'rest-client'
require 'json'
namespace :hair do
  
  task :create_shipwire_orders => :environment do

    Shipwire.configure do |config|
      config.username = "ronnie@hairillusion.com"
      config.password = "Zack1369!"
      config.endpoint = URI::encode('https://api.shipwire.com')
    end
    normal_orders = Order.where("order_type != 'recurrent' and refunded_at is null and shipment_id is null")
    #get unshipped orders first
    orders = Order.joins("LEFT JOIN order_deliveries ON orders.id = order_deliveries.order_id JOIN customers ON orders.orderer_id = customers.id")
                .select("orders.id, orderer_id")
                .limit(1)
    orders.each do |order|
      #get information
      order_id = order.id

      #get  items
      items = OrderItem.joins(:product)
                  .where(order_id: order_id)
                  .select('products.sku as sku, order_items.*')
      #get production information

      #get customer information
      customer = Customer.find_by(id: order.orderer_id)
      p customer
      #get general order information
      #for each order make POST request

      #now create shipwire order

      #items generation
      order_items = []
      items.each do |item|
        order_items << { :sku => item.sku, :quantity => item.quantity, :commercialInvoiceValue => item.price, :commercialInvoiceValueCurrency => 'USD'}
      end

      shipwire_order = {
          :orderNo      => "##{order_id}TEST",
          :externalId   => "#{order_id}EXTERNAL",
          :processAfterDate => nil,
          # List of items ordered
          :items => order_items,
=begin
          :items => [
              {
                  # Item's SKU
                  :sku => sku,
                  # Number of items to order
                  :quantity => quantity,
                  # Amount to show in invoice (for customs declaration purposes)
                  :commercialInvoiceValue => price,
                  # Currency for the above value
                  :commercialInvoiceValueCurrency => 'USD'
              }
          ],
=end
          :options => {
              # Specify one of warehouseId, warehouseExternalId, warehouseRegion, warehouseArea
              :warehouseId          => nil,
              :warehouseExternalId  => nil,
              :warehouseRegion      => nil,
              :warehouseArea        => nil,
              # Service requested for this order
              :serviceLevelCode     => 'GD',
              # Delivery carrier requested for this order
              :carrierCode          => nil,
              # Was "Same Day" processing requested ?
              :sameDay  => 'NOT REQUESTED',
              # Used to assign a pre-defined set of shipping and/or customization preferences on an order.
              # A channel must be defined prior to order creation for the desired preferences to be applied.
              # Please contact us if you believe your application requires a channel.
              :channelName => nil,
              :forceDuplicate => 0,
              :forceAddress   => 00,
              :carrierAccountNumber => nil,
              :referrer             =>  'Hair Illusion Ruby App',
              :affiliate      => nil,
              :currency => 'USD',
              # Specifies whether the items to be shipped can be split into two packages if needed
              :canSplit => 1,
              # Set a manual hold
              :note => "notes",
              :hold    => 1,
              # A discount code
              :holdReason    => "test reason",
              :discountCode    => "FREE STUFF",
              :server    => "Production"
          },
          # Shipping source
          :shipFrom    => { :company => 'Hair Illusion'},
          :shipTo    => {
              # Recipient details
              :email    => customer.email,
              :name    => customer.first_name + " " + customer.last_name,
              :company    => "",
              :address1    => customer.address1,
              :address2    => customer.address2,
              :address3    => "",
              :city        => customer.city,
              :state       => customer.state,
              :postalCode  => customer.zip,
              :country    =>  customer.country,
              :phone      => '',
              # Specifies whether the recipient is a commercial entity. 0 = no, 1 = yes
              :isCommercial    => 0,
              # Specifies whether the recipient is a PO box. 0 = no, 1 = yes
              :isPoBox    => 0
          },
          # Invoiced amounts (for customs declaration only)
          :commercialInvoice    => {
              # Amount for shipping service
              :shippingValue    => 8.95,
              # Amount for insurance
              :insuranceValue    => 0,
              :additionalValue    => 0,
              # Currencies to interpret the amounts above
              :shippingValueCurrency    => "USD",
              :insuranceValueCurrency    => "USD",
              :additionalValueCurrency    => "USD"
          },
          # Message to include in package
          :packingList    => {
              :message1    => {
                  :body    => "This must be where pies go when they die. Enjoy!",
                  :header    => "Testing ship wire!"
              }
          }
      }
      #on successful, add entries...
      p shipwire_order
      p '--------------___JSON_-----------------------'
      p shipwire_order.to_json

      p  ".........................."
      new_order = Shipwire::Orders.new
      response = new_order.create(shipwire_order)
      p response
      if(response.body['status'] == 200)
        #if successful, mark as 'shipped'
        OrderDelivery.create(:order_id => order_id)
        order.update_attribute(:last_delivery_date, Date.today)
        order.update_attribute(:next_delivery_date, Date.today+15.days)
        #add shipped entry
      else
        p response.error_report
      end

      p ".........................."
    end


  end
   
 
end
