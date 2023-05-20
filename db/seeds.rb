USERS_TO_CREATE = 2
CLIENTS_TO_CREATE = 2
ADDRESSES_TO_CREATE = 8 ### Based on an array of 8 real addresses
APPOINTMENTS_TO_CREATE = 4 ### ⚠️ Appointments created every day between May 1st and 15th

Dir[Rails.root.join("db", "seeds", "*.rb")].sort.each do |file|
  require file
end
