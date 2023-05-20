# Create n random clients
CLIENTS_TO_CREATE.times do
  client = Client.create(
    name: Faker::Company.name,
    email: Faker::Internet.email
  )

  if client.persisted?
    puts "🥳 Created client #{client.email}"
  else
    puts "⛔️ Failed to create client: #{client.errors.full_messages.join(', ')}"
  end
end

puts "#############################################"
puts "#############################################"
