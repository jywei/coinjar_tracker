# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create currencies for CoinJar API
puts "Creating currencies..."

Currency.find_or_create_by!(name: "Bitcoin", symbol: "BTCAUD") do |currency|
  puts "Created Bitcoin (BTCAUD)"
end

Currency.find_or_create_by!(name: "Ethereum", symbol: "ETHAUD") do |currency|
  puts "Created Ethereum (ETHAUD)"
end

puts "Seed data created successfully!"
puts "You can now run the application and use the 'Capture Latest Prices' button to fetch current prices."
