require 'rest-client'
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
      items = OrderItem.where(order_id: order_id)
      #get production information

      #get customer information
      customer = Customer.find_by(id: order.orderer_id)
      p customer
      #get general order information
      #for each order make POST request

      #now create shipwire order
      sku = "Test Product 001"

      #items generation
      order_items = []
      items.each do |item|
        order_items << { :sku => sku, :quantity => item.quantity, :commercialInvoiceValue => item.price, :commercialInvoiceValueCurrency => 'USD'}
      end

      shipwire_order = {
          :orderNo      => "foobar1",
          :externalId   => "rFooBar1",
          :processAfterDate => Time.now.to_i,
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
              :warehouseRegion      => 'LAX',
              :warehouseArea        => nil,
              # Service requested for this order
              :serviceLevelCode     => '1D',
              # Delivery carrier requested for this order
              :carrierCode          => nil,
              # Was "Same Day" processing requested?
              :sameDay  => 'NOT REQUESTED',
              # Used to assign a pre-defined set of shipping and/or customization preferences on an order.
              # A channel must be defined prior to order creation for the desired preferences to be applied.
              # Please contact us if you believe your application requires a channel.
              :channelName => 'My Channel',
              :forceDuplicate => 0,
              :forceAddress   => 00,
              :carrierAccountNumber => 'qwer1234',
              :referrer             =>  'Foo Referrer',
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
              :shippingValue    => 4.85,
              # Amount for insurance
              :insuranceValue    => 6.57,
              :additionalValue    => 8.29,
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
      p shipewire_order.to_json

      p  ".........................."
      #order = Shipwire::Orders.new
      new_order = Shipwire::Orders.new
      response = new_order.list({username:'ronnie@hairillusion.com', password:'Zack1369!'})
      p response
      response = new_order.create(shipwire_order)
      p response
      p ".........................."
    end


  end
   
 
end
