# Create n random users
USERS_TO_CREATE.times do
  user = User.create(
    first_name: Faker::Name.name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    time_zone: 'Zurich',
    locale: 'it',
    password: 'stropass123',
    password_confirmation: 'stropass123'
  )

  if user.persisted?
    puts "🥳 Created user #{user.email} - pw: #{user.password}"
  else
    puts "⛔️ Failed to create user: #{user.errors.full_messages.join(', ')}"
  end
end

puts "#############################################"
puts "All users created! 🎉"
puts "Now I am going to create addresses and patients."
puts "#############################################"
