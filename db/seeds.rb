# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Create one client
name = Faker::Company.name
email = Faker::Internet.email
client = Client.create(name: name, email: email)
puts "Created client #{client.name}"

# Create 5 patients with addresses between Winterthur and Volketswil
patient_addresses = [
  'Webergasse 25, 8400 Winterthur, Switzerland',
  'Hegmattenstrasse 6, 8404 Winterthur, Switzerland',
  'Lindbergstrasse 10, 8302 Kloten, Switzerland',
  'Rütistrasse 15, 8600 Dübendorf, Switzerland',
  'Dorfstrasse 50, 8604 Volketswil, Switzerland'
]

patient_addresses.each do |address|
  patient = client.patients.build(
    name: Faker::Name.name,
    address: address
  )
  if patient.save
    puts "Created patient #{patient.name}"
  else
    puts "Failed to create patient: #{patient.errors.full_messages.join(', ')}"
  end
end



# Create 3 users with addresses between Winterthur and Volketswil
user_addresses = [
  'Feldstrasse 19, 8400 Winterthur, Switzerland',
  'Dorfstrasse 23, 8600 Dübendorf, Switzerland',
  'Bodenäckerstrasse 8, 8604 Volketswil, Switzerland'
]

user_addresses.each do |address|
  user = User.create(
    name: Faker::Name.name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: 'stropass123',
    password_confirmation: 'stropass123',
    address: address
  )
  if user.persisted?
    puts "Created user #{user.email} - pw: #{user.password}"
  else
    puts "Failed to create user: #{user.errors.full_messages.join(', ')}"
  end
end

# Create 5 treatments per day between April 1st and April 7th
users = User.all
patients = Patient.all

(1..7).each do |day|
  date = DateTime.new(2023, 4, day)
  5.times do
    start_time = date + rand(8..18).hours + rand(0..59).minutes
    end_time = start_time + rand(30..120).minutes

    user = users.sample
    patient = patients.sample

    # Check if both user and patient are present
    if user && patient
      Treatment.create(
        user: user,
        patient: patient,
        start_time: start_time,
        end_time: end_time
      )
      puts "Created a treatment by #{user.email} to #{patient.name} between #{start_time} and #{end_time}"
    else
      puts "Failed to create a treatment due to missing user or patient"
    end
  end
end
