# Create 8 addresses based on the given array of real addresses between Winterthur and Volketswil
addresses = [
  'Poststrasse 7, 8610 Uster, Zurich, Switzerland',
  'Seestrasse 15, 8330 Pfäffikon, Zurich, Switzerland',
  'Lindbergstrasse 10, 8404 Winterthur, Zurich, Switzerland',
  'Rütistrasse 15, 8600 Dübendorf, Zurich, Switzerland',
  'Dorfstrasse 50, 8604 Volketswil, Zurich, Switzerland',
  'Im Moos 5, 8307 Illnau-Effretikon, Zurich, Switzerland',
  'Dorfstrasse 23, 8600 Dübendorf, Zurich, Switzerland',
  'Bodenackerstrasse 8, 8304 Wallisellen, Zurich, Switzerland'
]

addresses.each do |full_address|
  parts = full_address.split(', ')
  street_and_number = parts[0].split(' ')
  number = street_and_number.pop
  street = street_and_number.join(' ')
  zip_code = parts[1].split(' ')[0]
  city = parts[1].split(' ')[1]
  state = parts[2]
  country = parts[3]

  address_attrs = {
    street: street,
    number: number,
    zip_code: zip_code,
    city: city,
    state: state,
    country: country
  }

  address = Address.create(address_attrs)

  if address.persisted?
    patient = Patient.new(name: Faker::Name.name, address_id: address.id)

    if patient.save
      puts "💊 Created patient #{patient.name} at #{address.street} #{address.number}, #{address.zip_code} #{address.city}, #{address.state}, #{address.country}"
    else
      puts "⛔️ Failed to create patient: #{patient.errors.full_messages.join(', ')}"
    end
  else
    puts "⛔️ Failed to create address: #{address.errors.full_messages.join(', ')}"
  end

  sleep(2) # Wait for 2 seconds
end

puts "#############################################"
puts "Addresses and patients created! 🎉"
puts "Now it is your turn to create appointments and trips 🚗"
puts "Enjoy Calcometer ^___^ 👋"
puts "#############################################"
