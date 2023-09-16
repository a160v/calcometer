class TripCalculator < ApplicationService
  OPENROUTE_API_KEY = ENV['OPENROUTE_API_KEY'] || ""

  def initialize(appointments)
    @appointments = appointments
  end

  def call
    calculate_daily_driving_distance_and_duration_from_openroute
  end

  private

  def calculate_daily_driving_distance_and_duration_from_openroute
    return unless @appointments

    coordinates = collect_valid_coordinates
    if coordinates.empty?
      log_error("No valid coordinates found")
      return [nil, nil]
    end
    response = make_api_request(coordinates)
    if response.success?
      driving_distance, driving_duration, user_id = parse_response_and_save_trip(response)
      return [driving_distance.round(2), driving_duration.round]
    else
      log_error("API response error: #{response}")
      return [nil, nil]
    end
  end

  def collect_valid_coordinates
    coordinates = []
    @appointments.each do |appointment|
      appointment_coordinates = appointment.coordinates
      coordinates << appointment_coordinates if valid_coordinates?(appointment_coordinates)
    end
    coordinates
  end

  def valid_coordinates?(coordinates)
    coordinates.is_a?(Array) && coordinates.length == 2
  end

  def make_api_request(coordinates)
    url = 'https://api.openrouteservice.org/v2/directions/driving-car/json'
    headers = {
      accept: 'application/json, application/geo+json; charset=utf-8',
      Authorization: OPENROUTE_API_KEY,
      'Content-Type': 'application/json;charset=utf-8'
    }
    values = { coordinates: }
    HTTParty.post(url, body: values.to_json, headers:)
  end

  def parse_response_and_save_trip(response)
    if response.success?
      route_data = response.parsed_response
      driving_distance, driving_duration = extract_distance_and_duration(route_data)
      user_id = @appointments.first.user_id
      Trip.save_or_update_trip(driving_distance, driving_duration, user_id)
      [driving_distance, driving_duration, user_id]
    else
      log_error("API response error: #{response}")
      [nil, nil, nil]
    end
  end

  def extract_distance_and_duration(route_data)
    summary = route_data['routes'].first['summary']
    distance = summary['distance'] / 1000.0
    duration = summary['duration'] / 60.0
    [distance, duration]
  end

  def log_error(message)
    Rails.logger.error(message)
  end
end
