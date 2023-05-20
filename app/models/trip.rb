class Trip < ApplicationRecord
  belongs_to :start_appointment, class_name: 'Appointment', optional: false
  belongs_to :end_appointment, class_name: 'Appointment', optional: false

  # Validate that start_appointment and end_appointment are not the same
  validate :different_appointments

  AVERAGE_SPEED = 50.0 # Average driving speed in Switzerland (in km/h)

  after_save :update_driving_distance_and_time

  def update_driving_distance_and_time
    return unless valid_appointments?

    update_columns(
      driving_distance: calculate_driving_distance,
      driving_time: calculate_driving_time
    )
  end

  private

  def calculate_driving_distance
    @calculate_driving_distance ||= begin
      coordinates1 = fetch_coordinates(start_appointment.patient.address)
      coordinates2 = fetch_coordinates(end_appointment.patient.address)
      Geocoder::Calculations.distance_between(coordinates1, coordinates2) if coordinates1 && coordinates2
    end
  end

  def calculate_driving_time
    @calculate_driving_time ||= (calculate_driving_distance.to_f / AVERAGE_SPEED * 60).round if calculate_driving_distance
  end

  def fetch_coordinates(address)
    Rails.cache.fetch(address, expires_in: 1.week) do
      Geocoder.coordinates(address) || log_unfound_coordinates(address)
    end
  end

  def log_unfound_coordinates(address)
    Rails.logger.warn "Coordinates not found for address: #{address}"
    nil
  end

  def different_appointments
    errors.add(:end_appointment, "can't be the same as start appointment") if start_appointment == end_appointment
  end

  def valid_appointments?
    start_appointment&.patient&.address && end_appointment&.patient&.address
  end
end
