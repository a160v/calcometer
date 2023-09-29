USERS_TO_CREATE = 2
ADDRESSES_AND_PATIENTS_TO_CREATE = 8 ### Based on an array of 8 real addresses
Dir[Rails.root.join("db", "seeds", "*.rb")].sort.each do |file|
  require file
end
