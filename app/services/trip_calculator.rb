class TripCalculator < ApplicationService
  # Constants
  OPENROUTE_API_KEY = ENV['OPENROUTE_API_KEY'] || ""

  def initialize(appointments)
    @appointments = appointments
  end

  def call
    calculate_daily_driving_distance_and_duration_from_openroute
  end

  private

  # Fetch the distance and duration from OpenRoute Service API
  def calculate_daily_driving_distance_and_duration_from_openroute
    return unless @appointments

    coordinates = []

    # Fetch all cordinates from each appointment
    @appointments.each do |appointment|
      appointment_coordinates = appointment.coordinates
      # Add coordinates to the array
      coordinates << appointment_coordinates if appointment_coordinates
    end

    # API Endpoint
    url = 'https://api.openrouteservice.org/v2/directions/driving-car/json'

    # Headers
    headers = {
      accept: 'application/json, application/geo+json; charset=utf-8',
      Authorization: OPENROUTE_API_KEY,
      'Content-Type': 'application/json;charset=utf-8'
    }

    # Body
    values = { coordinates: coordinates }

    # Make the API call
    response = HTTParty.post(url, body: values.to_json, headers: headers)

    # Parse the response
    if response.success?
      route_data = response.parsed_response
      summary = route_data['routes'].first['summary']
      driving_distance = (summary['distance'] / 1000.0)
      driving_duration = (summary['duration'] / 60.0)

      # Get the user_id from the first appointment
      user_id = @appointments.first.user_id

      # Save or update the trip details in the database
      Trip.save_or_update_trip(driving_distance, driving_duration, user_id)

      return [driving_distance.round(2), driving_duration.round]
    else
      Rails.logger.error("API response did not work as expected. Response: #{response}") # Log error
      return [nil, nil] # Return nil values
    end

    render json: { driving_distance: @driving_distance, driving_duration: @driving_duration }
  end
end
