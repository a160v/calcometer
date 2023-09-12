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
      daily_distance = (summary['distance'] / 1000.0).round(2)
      daily_duration = (summary['duration'] / 60.0).round

      # Save or update the trip details in the database
      Trip.save_or_update_trip(daily_distance, daily_duration)

      return [daily_distance, daily_duration]
    else
      Rails.logger.error("API response did not work as expected. Response: #{response}") # Log error
      return [nil, nil] # Return nil values
    end

    render json: { daily_distance: @daily_distance, daily_duration: @daily_duration }
    save_or_update_trip
  end
end
