namespace :hair do
  
  task :create_shipwire_orders => :environment do
    normal_orders = Order.where("order_type != 'recurrent' and refunded_at is null and shipment_id is null")
    #get unshipped orders first

    #for each order make POST request

    #now create shipwire order
    order = {
        :orderNo      => "foobar1",
        :externalId   => "rFooBar1",
        :processAfterDate => Date.NOW(),
    # List of items ordered
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
            :shipFrom    => { :company => 'We Sellem Co.'},
            :shipTo    => {
            # Recipient details
             :email    => "audrey.horne@greatnothern.com",
             :name    => "Audrey Horne",
             :company    => "Audrey's Bikes",
             :address1    => "6501 Railroad Avenue SE",
             :address2    => "Room 315",
             :address3    => "",
             :city    => "Snoqualmie",
             :state    => "WA",
             :postalCode    => "98065",
             :country    => "US",
             :phone    => "4258882556",
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
  end
   
 
end
