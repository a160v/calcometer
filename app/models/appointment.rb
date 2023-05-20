class Appointment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :patient, optional: true
  has_one :address, through: :patient
  has_one :start_trip, class_name: 'Trip', foreign_key: 'start_appointment_id', dependent: :destroy
  has_one :end_trip, class_name: 'Trip', foreign_key: 'end_appointment_id', dependent: :destroy

  validates :start_time, :end_time, presence: true
  validate :validate_time, :no_overlapping_appointments

  after_destroy :recalculate_trip

  def validate_time
    errors.add(:end_time, "must be after start time") if
      end_time < start_time

    errors.add(:start_time, "cannot be equal to start time") if
      end_time == start_time

    errors.add(:start_time, "| You have already created another appointment for this time today.") if
      Appointment.where(user_id: user_id, start_time: start_time).where.not(id: id).exists?
  end

  def no_overlapping_appointments
    today = Time.current.beginning_of_day
    tomorrow = Time.current.end_of_day

    overlapping_appointments = Appointment.where(user_id: user_id).where.not(id: id)
                                          .where("start_time BETWEEN ? AND ?", today, tomorrow)
                                          .where("start_time < ? AND end_time > ?", end_time, start_time)

    errors.add(:start_time, "The appointment period overlaps with another existing appointment.") if
      overlapping_appointments.exists?
  end

  def recalculate_trip
    RecalculateTripJob.perform_later(self.id)
  end
end
