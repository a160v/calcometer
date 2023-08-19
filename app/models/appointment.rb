class Appointment < ApplicationRecord
  # Associations
  belongs_to :user, optional: true
  belongs_to :patient, optional: true
  has_one :address, through: :patient
  has_one :start_trip, class_name: 'Trip', foreign_key: 'start_appointment_id', dependent: :destroy
  has_one :end_trip, class_name: 'Trip', foreign_key: 'end_appointment_id', dependent: :destroy

  # Validations
  validates :start_time, :end_time, presence: true
  validate :validate_time, :no_overlapping_appointments

  # Callbacks
  after_destroy :recalculate_trip
  after_save :create_trip

  # Validation method to ensure that the end_time is after the start_time
  def validate_time
    if end_time < start_time
      errors.add(:end_time, "must be after start time")
    elsif end_time == start_time
      errors.add(:start_time, "cannot be equal to start time")
    elsif Appointment.where(user_id: user_id, start_time: start_time).where.not(id: id).exists?
      errors.add(:start_time, "| You have already created another appointment for this time today.")
    end
  end

  # Validation method to ensure that the appointment times do not overlap
  def no_overlapping_appointments
    today = Time.current.beginning_of_day
    tomorrow = Time.current.end_of_day

    overlapping_appointments = Appointment.where(user_id: user_id).where.not(id: id)
                                          .where("start_time BETWEEN ? AND ?", today, tomorrow)
                                          .where("start_time < ? AND end_time > ?", end_time, start_time)

    if overlapping_appointments.exists?
      errors.add(:start_time, "The appointment period overlaps with another existing appointment.")
    end
  end

  # After an appointment is destroyed, this callback will recalculate the trip
  def recalculate_trip
    RecalculateTripJob.perform_now
  end
  # Find the next appointment for the user after the current appointment
  def next_appointment
    user.appointments.where('start_time > ?', end_time).order(:start_time).first
  end

  # Retrieve and transform longitude and latitude from address
  def coordinates
    [address.longitude.to_f, address.latitude.to_f]
  end

  # After saving an appointment, this callback will create a trip to the next appointment
  def create_trip
    Rails.logger.info("Inside create_trip method for Appointment ID: #{self.id}")

    return unless next_appointment

    Rails.logger.info("Found next appointment with ID: #{next_appointment.id}")

    if end_trip
      Rails.logger.info("Updating existing end_trip with ID: #{end_trip.id}")
      end_trip.update(end_appointment: next_appointment)
    else
      Rails.logger.info("Creating a new trip.")
      trip = Trip.new(start_appointment: self, end_appointment: next_appointment)
      distance, duration = trip.send(:calculate_driving_distance_and_duration)
      trip.driving_distance = distance
      trip.driving_duration = duration
      if trip.save
        Rails.logger.info("Trip created successfully.")
      else
        Rails.logger.error("Failed to save trip. Errors: #{trip.errors.full_messages.join(', ')}")
      end
    end
  end
end
