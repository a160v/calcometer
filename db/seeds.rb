# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

# Create one client
name = Faker::Company.name
email = Faker::Internet.email
client = Client.create(name: name, email: email)
puts "Created client #{client.name}"

# Create 8 addresses with addresses between Winterthur and Volketswil
addresses = [
  'Poststrasse 7, 8610 Uster, Zurich, Switzerland',
  'Hegmattenstrasse 6, 8404 Winterthur, Zurich, Switzerland',
  'Lindbergstrasse 10, 8404 Winterthur, Zurich, Switzerland',
  'Rütistrasse 15, 8600 Dübendorf, Zurich, Switzerland',
  'Dorfstrasse 50, 8604 Volketswil, Zurich, Switzerland',
  'Im Moos 5, 8307 Illnau-Effretikon, Zurich, Switzerland',
  'Dorfstrasse 23, 8600 Dübendorf, Zurich, Switzerland',
  'Bodenackerstrasse 8, 8304 Wallisellen, Zurich, Switzerland'
]

address_data = addresses.map do |full_address|
  street_and_number, zip_and_city, _state, _country = full_address.split(', ')

  street = street_and_number.rpartition(' ')[0]
  number = street_and_number.rpartition(' ')[-1]
  zip_code = zip_and_city.split(' ')[0]
  city = zip_and_city.split(' ')[1..].join(' ')

  { street: street.strip, number: number.strip, zip_code: zip_code, city: city, state: 'Zurich', country: 'Switzerland' }
end

  address_data.each do |data|
    address = Address.find_or_create_by(data)

    if address.persisted?
      patient = client.patients.create(name: Faker::Name.name, address: address)

      if patient.persisted?
        puts "Created patient #{patient.name}"
      else
        puts "Failed to create patient: #{patient.errors.full_messages.join(', ')}"
      end
    else
      puts "Failed to create address: #{address.errors.full_messages.join(', ')}"
    end

sleep(1.5) # Wait for 1 second
end


# Create 3 users
3.times do
  user = User.create(
    name: Faker::Name.name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: 'stropass123',
    password_confirmation: 'stropass123'
  )

  if user.persisted?
    puts "Created user #{user.email} - pw: #{user.password}"
  else
    puts "Failed to create user: #{user.errors.full_messages.join(', ')}"
  end
end

# Create 5 appointments per day between May 1st and May 15th
users = User.all
patients = Patient.all

(1..15).each do |day|
  date = DateTime.new(2023, 5, day)
  3.times do
    start_time = date + rand(8..18).hours + rand(0..59).minutes
    end_time = start_time + rand(30..120).minutes

    user = users.sample
    patient = patients.sample

    # Check if both user and patient are present
    if user && patient
      Appointment.create(
        user: user,
        patient: patient,
        start_time: start_time,
        end_time: end_time
      )
      puts "Created a appointment by #{user.name} to #{patient.name} between #{start_time} and #{end_time}"
    else
      puts "Failed to create a appointment due to missing user or patient"
    end
  end
end
