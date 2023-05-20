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

clients = Client.all
# Iterate through the array of addresses and create a list of addresses
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
  client = clients.sample

  if address.persisted?
    patient = client.patients.create(name: Faker::Name.name, address: address, client: client)

    if patient.persisted?
      puts "💊 Created patient #{patient.name}"
    else
      puts "⛔️ Failed to create patient: #{patient.errors.full_messages.join(', ')}"
    end
  else
    puts "⛔️ Failed to create address: #{address.errors.full_messages.join(', ')}"
  end

sleep(2) # Wait for 2 seconds
end

puts "#############################################"
puts "#############################################"
