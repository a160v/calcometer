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
    RecalculateTripJob.perform_later(self.id)
  end

  # Find the next appointment for the user after the current appointment
  def next_appointment
    user.appointments.where('start_time > ?', end_time).order(:start_time).first
  end

  # After saving an appointment, this callback will create a trip to the next appointment
  def create_trip
    return unless next_appointment

    if end_trip
      end_trip.update(end_appointment: next_appointment)
    else
      Trip.create(start_appointment: self, end_appointment: next_appointment)
    end
  end
end
