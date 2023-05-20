module AppointmentsHelper
  ### CALCULATION LOGIC MOVED TO TRIP.RB
  # AVERAGE_SPEED = 50.0 # Average driving speed in Switzerland (in km/h)

  # # Fetch the total distance driven by car between each appointment;
  # # reiterate with all appointments for a given day

  # def calculate_driving_distance(address1, address2)
  #   # Geocoding the addresses to get coordinates
  #   coordinates1 = fetch_coordinates(address1)
  #   coordinates2 = fetch_coordinates(address2)

  #   # Check if coordinates are available
  #   return 0.0 unless coordinates1 && coordinates2

  #   # Calculate distance using Geocoder::Calculations.distance_between
  #   Geocoder::Calculations.distance_between(coordinates1, coordinates2)
  # end

  # def calculate_driving_time(distance)
  #   # Calculate driving time in hours
  #   time_in_hours = distance.round(2) / AVERAGE_SPEED
  #   # Convert driving time to minutes
  #   (time_in_hours * 60).round
  # end

  # private

  # def fetch_coordinates(address)
  #   Rails.cache.fetch(address, expires_in: 1.week) do
  #     Geocoder.coordinates(address) || log_unfound_coordinates(address)
  #   end
  # end

  # def log_unfound_coordinates(address)
  #   Rails.logger.warn "Coordinates not found for address: #{address}"
  #   nil
  # end
end
