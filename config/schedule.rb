 
every 10.minutes do
  #runner "DomainDistributor.get_orders"
end  

every :day, :at => '12:20am' do
  rake "hair:generate_recurrent_orders"
end

every :day, :at => '12:50am' do
  rake "hair:create_shipwire_orders"
end