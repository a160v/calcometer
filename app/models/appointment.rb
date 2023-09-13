class Appointment < ApplicationRecord
  # Associations
  # acts_as_tenant :tenant, through: :patient
  belongs_to :tenant
  belongs_to :user
  belongs_to :patient
  has_one :address, through: :patient

  # Validations
  validates :start_time, :end_time, presence: true
  validate :validate_time, :no_overlapping_appointments

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

  # Retrieve and transform longitude and latitude from address
  def coordinates
    [address.longitude.to_f, address.latitude.to_f]
  end
end
