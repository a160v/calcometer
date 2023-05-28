class Trip < ApplicationRecord
  # Model associations
  belongs_to :start_appointment, class_name: 'Appointment', optional: false
  belongs_to :end_appointment, class_name: 'Appointment', optional: false

  # Validation
  validate :different_appointments

  # Constant representing average driving speed
  AVERAGE_SPEED = 50.0 # Average driving speed in km/h

  # Callbacks
  after_save :update_driving_distance_and_time

  # Ensures the start and end appointments are not the same
  def different_appointments
    errors.add(:end_appointment, "can't be the same as start appointment") if start_appointment == end_appointment
  end

  # Ensures both appointments have valid address
  def valid_appointments?
    start_appointment&.patient&.address && end_appointment&.patient&.address
  end

  # Callback method to update driving distance and time after saving
  def update_driving_distance_and_time
    return unless valid_appointments?

    update_columns(
      driving_distance: calculate_driving_distance,
      driving_time: calculate_driving_time
    )
  end

  # Method to calculate driving distance using Geocoder
  def calculate_driving_distance
    coordinates1 = start_appointment.address.latitude, start_appointment.address.longitude
    coordinates2 = end_appointment.address.latitude, end_appointment.address.longitude
    Geocoder::Calculations.distance_between(coordinates1, coordinates2) if coordinates1 && coordinates2
  end

  # Method to calculate driving time based on average speed
  def calculate_driving_time
    (calculate_driving_distance.to_f / AVERAGE_SPEED * 60).round if calculate_driving_distance
  end
end
