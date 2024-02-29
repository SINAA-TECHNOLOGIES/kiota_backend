# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Create some countries
# Create Countries
countries = Country.create([{ name: 'Country 1' }, { name: 'Country 2' }, { name: 'Country 3' }])

# Create Users
users = User.create([
  { name: 'User 1', email: 'user1@example.com', password: 'password', country_id: countries.first.id },
  { name: 'User 2', email: 'user2@example.com', password: 'password', country_id: countries.second.id },
  { name: 'User 3', email: 'user3@example.com', password: 'password', country_id: countries.third.id }
])

# Create Properties
properties = Property.create([
  { name: 'Property 1', country_id: countries.first.id },
  { name: 'Property 2', country_id: countries.second.id },
  { name: 'Property 3', country_id: countries.third.id }
])
