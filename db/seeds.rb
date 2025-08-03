puts "Creating currencies..."

btc = Currency.find_or_create_by!(name: "Bitcoin", symbol: "BTCAUD") do |currency|
  puts "Created Bitcoin (BTCAUD)"
end

eth = Currency.find_or_create_by!(name: "Ethereum", symbol: "ETHAUD") do |currency|
  puts "Created Ethereum (ETHAUD)"
end

puts "Creating historical price snapshots..."

PriceSnapshot.destroy_all

btc_prices = [
  { last: 176900, bid: 176200, ask: 177000, hours_ago: 0 },
  { last: 176500, bid: 175800, ask: 176600, hours_ago: 1 },
  { last: 176200, bid: 175500, ask: 176300, hours_ago: 2 },
  { last: 175800, bid: 175100, ask: 175900, hours_ago: 4 },
  { last: 175200, bid: 174500, ask: 175300, hours_ago: 6 },
  { last: 174500, bid: 173800, ask: 174600, hours_ago: 8 },
  { last: 173800, bid: 173100, ask: 173900, hours_ago: 12 },
  { last: 173200, bid: 172500, ask: 173300, hours_ago: 18 },
  { last: 172500, bid: 171800, ask: 172600, hours_ago: 24 },
  { last: 171800, bid: 171100, ask: 171900, hours_ago: 30 },
  { last: 171200, bid: 170500, ask: 171300, hours_ago: 36 },
  { last: 170500, bid: 169800, ask: 169900, hours_ago: 48 },
  { last: 169800, bid: 169100, ask: 169900, hours_ago: 60 },
  { last: 169200, bid: 168500, ask: 169300, hours_ago: 72 },
  { last: 168500, bid: 167800, ask: 168600, hours_ago: 84 },
  { last: 167800, bid: 167100, ask: 167900, hours_ago: 96 },
  { last: 167200, bid: 166500, ask: 167300, hours_ago: 108 },
  { last: 166500, bid: 165800, ask: 166600, hours_ago: 120 },
  { last: 165800, bid: 165100, ask: 165900, hours_ago: 132 },
  { last: 165200, bid: 164500, ask: 165300, hours_ago: 144 },
  { last: 164500, bid: 163800, ask: 164600, hours_ago: 156 },
  { last: 163800, bid: 163100, ask: 163900, hours_ago: 168 },
]

eth_prices = [
  { last: 5350, bid: 5354, ask: 5364, hours_ago: 0 },
  { last: 5345, bid: 5349, ask: 5359, hours_ago: 1 },
  { last: 5340, bid: 5344, ask: 5354, hours_ago: 2 },
  { last: 5335, bid: 5339, ask: 5349, hours_ago: 4 },
  { last: 5330, bid: 5334, ask: 5344, hours_ago: 6 },
  { last: 5325, bid: 5329, ask: 5339, hours_ago: 8 },
  { last: 5320, bid: 5324, ask: 5334, hours_ago: 12 },
  { last: 5315, bid: 5319, ask: 5329, hours_ago: 18 },
  { last: 5310, bid: 5314, ask: 5324, hours_ago: 24 },
  { last: 5305, bid: 5309, ask: 5319, hours_ago: 30 },
  { last: 5300, bid: 5304, ask: 5314, hours_ago: 36 },
  { last: 5295, bid: 5299, ask: 5309, hours_ago: 48 },
  { last: 5290, bid: 5294, ask: 5304, hours_ago: 60 },
  { last: 5285, bid: 5289, ask: 5299, hours_ago: 72 },
  { last: 5280, bid: 5284, ask: 5294, hours_ago: 84 },
  { last: 5275, bid: 5279, ask: 5289, hours_ago: 96 },
  { last: 5270, bid: 5274, ask: 5284, hours_ago: 108 },
  { last: 5265, bid: 5269, ask: 5279, hours_ago: 120 },
  { last: 5260, bid: 5264, ask: 5274, hours_ago: 132 },
  { last: 5255, bid: 5259, ask: 5269, hours_ago: 144 },
  { last: 5250, bid: 5254, ask: 5264, hours_ago: 156 },
  { last: 5245, bid: 5249, ask: 5259, hours_ago: 168 },
]

btc_prices.each do |price_data|
  PriceSnapshot.create!(
    currency: btc,
    last: price_data[:last],
    bid: price_data[:bid],
    ask: price_data[:ask],
    captured_at: price_data[:hours_ago].hours.ago
  )
end

eth_prices.each do |price_data|
  PriceSnapshot.create!(
    currency: eth,
    last: price_data[:last],
    bid: price_data[:bid],
    ask: price_data[:ask],
    captured_at: price_data[:hours_ago].hours.ago
  )
end

puts "Seed data created successfully!"
puts "Created #{btc_prices.size} Bitcoin price snapshots"
puts "Created #{eth_prices.size} Ethereum price snapshots"
puts "Total: #{btc_prices.size + eth_prices.size} price snapshots"
puts "Can now run the application and see default historical price data."
