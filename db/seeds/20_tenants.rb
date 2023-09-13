# Create n random tenants
TENANTS_TO_CREATE.times do
  tenant = Tenant.create(
    name: Faker::Company.name,
    email: Faker::Internet.email
  )

  if tenant.persisted?
    puts "🥳 Created tenant #{tenant.email}"
  else
    puts "⛔️ Failed to create tenant: #{tenant.errors.full_messages.join(', ')}"
  end
end

puts "#############################################"
puts "#############################################"
