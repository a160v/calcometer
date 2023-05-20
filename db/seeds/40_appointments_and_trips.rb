require 'geocoder'

# Create 3 appointments per day between May 1st and May 15th
users = User.all
patients = Patient.all

(1..15).each do |day|
  date = DateTime.new(2023, 5, day)
  APPOINTMENTS_TO_CREATE.times do
    start_time = date + rand(8..18).hours + rand(0..59).minutes
    end_time = start_time + rand(30..120).minutes

    user = users.sample
    patient = patients.sample

    # Check if both user and patient are present
    if user && patient
      appointment = Appointment.create(
        user: user,
        patient: patient,
        start_time: start_time,
        end_time: end_time
      )

      if appointment.persisted?
        puts "🤝 Created an appointment by #{user.name} to #{patient.name} between #{start_time} and #{end_time}"

        # Let's create a trip for this appointment
        previous_appointment = user.appointments.where("end_time < ?", appointment.start_time).order(end_time: :desc).first
        if previous_appointment
          # We have a previous appointment to generate a trip from
          start_address = previous_appointment.patient.address.full_address
        else
          # If there was no previous appointment, we will consider the patient's address as the starting point for the trip
          start_address = appointment.patient.address.full_address
        end

        end_address = appointment.patient.address.full_address

        # Replace Google Maps API call with Geocoder call
        distance = Geocoder::Calculations.distance_between(start_address, end_address)
        time = (distance / 50) * 60 # Assuming an average speed of 50 km/h

        Trip.create(
          start_appointment: previous_appointment,
          end_appointment: appointment,
          driving_distance: distance,
          driving_time: time
        )
        puts "🚙 Created a trip from #{start_address} to #{end_address} with driving distance: #{distance} km and time: #{time} minutes"
        sleep(2) # Wait for 2 seconds to not exceed rate limit of the API
      else
        puts "⛔️ Failed to create a appointment due to missing user or patient"
      end
    end
  end
end

puts "#############################################"
puts "#############################################"
