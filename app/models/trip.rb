class Trip < ApplicationRecord
  # Constants
  OPENROUTE_API_KEY = ENV['OPENROUTE_API_KEY'] || ""

  # Model associations
  belongs_to :start_appointment, class_name: 'Appointment', optional: false
  belongs_to :end_appointment, class_name: 'Appointment', optional: false

  # Fetch the distance and duration from OpenRoute Service API
  def calculate_driving_distance_and_duration
    coordinates1 = start_appointment.coordinates
    coordinates2 = end_appointment.coordinates

    # API Endpoint
    url = 'https://api.openrouteservice.org/v2/directions/driving-car/json'

    # Headers
    headers = {
      accept: 'application/json, application/geo+json; charset=utf-8',
      Authorization: OPENROUTE_API_KEY,
      'Content-Type': 'application/json;charset=utf-8'
    }

    # Body
    values = { coordinates: [coordinates1, coordinates2] }

    # Make the API call
    response = HTTParty.post(url, body: values.to_json, headers: headers)

    # Parse the response
    if response.success?
      route_data = response.parsed_response
      summary = route_data['routes'].first['summary']
      distance = (summary['distance'] / 1000.0)
      duration = (summary['duration'] / 60.0)

      return [distance, duration]
    else
      Rails.logger.error("API response did not work as expected. Response: #{response}") # Log error
      return [nil, nil] # Return nil values
    end
  end
end
