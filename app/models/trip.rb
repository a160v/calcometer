class Trip < ApplicationRecord
  belongs_to :start_appointment, class_name: 'Appointment', optional: false
  belongs_to :end_appointment, class_name: 'Appointment', optional: false

  # Validate that start_appointment and end_appointment are not the same
  validate :different_appointments

  def calculate_driving_distance
    coordinates1 = Geocoder.coordinates(start_appointment.address)
    coordinates2 = Geocoder.coordinates(end_appointment.address)
    if coordinates1.nil? || coordinates2.nil?
      raise "Coordinates not found for one or both addresses: #{start_appointment.address}, #{end_appointment.address}"
    end

    self.driving_distance = Geocoder::Calculations.distance_between(coordinates1, coordinates2)
  end

  def calculate_driving_time
    average_speed = 50.0
    time_in_hours = self.distance.round(2) / average_speed
    self.time = (time_in_hours * 60).round
  end

  private

  def different_appointments
    errors.add(:end_appointment, "can't be the same as start appointment") if start_appointment == end_appointment
  end
end
