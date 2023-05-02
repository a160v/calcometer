module TreatmentsHelper
  # Fetch the total distance driven by car between each treatment;
  # reiterate with all treatments for a given day
  def calculate_distance(address1, address2)

    # Geocoding the addresses to get coordinates
    coordinates1 = Geocoder.coordinates(address1)
    coordinates2 = Geocoder.coordinates(address2)

    # Check if coordinates are available
    if coordinates1.nil? || coordinates2.nil?
      raise "Coordinates not found for one or both addresses: #{address1}, #{address2}"
    end

    # Calculate distance using Geocoder::Calculations.distance_between
    distance = Geocoder::Calculations.distance_between(coordinates1, coordinates2)

    return distance
  end

  def calculate_driving_time(distance)
    # Average driving speed in Switzerland (in km/h)
    average_speed = 50.0

    # Calculate driving time in hours
    time_in_hours = distance.round(2) / average_speed

    # Convert driving time to minutes
    time_in_minutes = (time_in_hours * 60).round

    return time_in_minutes
  end
end
