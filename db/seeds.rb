# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Create a client
client = Client.create(name: Faker::Company.name)

# Create 5 patients with addresses between Winterthur and Volketswil
patient_addresses = [
  'Webergasse 25, 8400 Winterthur, Switzerland',
  'Hegmattenstrasse 6, 8404 Winterthur, Switzerland',
  'Lindbergstrasse 10, 8302 Kloten, Switzerland',
  'Rütistrasse 15, 8600 Dübendorf, Switzerland',
  'Dorfstrasse 50, 8604 Volketswil, Switzerland'
]

patient_addresses.each do |address|
  Patient.create(
    name: Faker::Name.name,
    address: address,
  )
end

# Create 3 users with addresses between Winterthur and Volketswil
user_addresses = [
  'Feldstrasse 19, 8400 Winterthur, Switzerland',
  'Dorfstrasse 23, 8600 Dübendorf, Switzerland',
  'Bodenäckerstrasse 8, 8604 Volketswil, Switzerland'
]

user_addresses.each do |address|
  User.create(
    email: Faker::Internet.email,
    password: 'aleks1',
    password_confirmation: 'aleks1',
    address: address
  )
end

# Create 5 treatments per day between April 1st and April 7th
users = User.all
patients = Patient.all

(1..7).each do |day|
  date = DateTime.new(2023, 4, day)
  5.times do
    start_time = date + rand(8..18).hours + rand(0..59).minutes
    end_time = start_time + rand(30..120).minutes

    Treatment.create(
      user: users.sample,
      patient: patients.sample,
      start_time: start_time,
      end_time: end_time
    )
  end
end
