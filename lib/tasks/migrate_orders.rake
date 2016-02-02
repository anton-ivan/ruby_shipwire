namespace :hair do

  task :parse_orders => :environment do 
    require 'csv'

    csv_text = File.read('doc/orders.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each_with_index do |row,index|  
      Order.save_order(row) #if index == 0
    end

  end

end