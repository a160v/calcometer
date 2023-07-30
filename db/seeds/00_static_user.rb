# Create Aleks user
user = User.create(
  first_name: 'Aleks',
  last_name: 'Starlord',
  email: 'aleks@starlord.com',
  password: 'stropass123',
  password_confirmation: 'stropass123'
)

if user.persisted?
  puts "Created user #{user.first_name} #{user.last_name}"
else
  puts "Failed to create user: #{user.errors.full_messages.join(', ')}"
end

puts "#############################################"
puts "#############################################"
