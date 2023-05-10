class Treatment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :patient, optional: true
  has_one :address, through: :patient

  validates :start_time, :end_time, presence: true
  validate :validate_time, :no_overlapping_treatments

  def validate_time
    errors.add(:end_time, "must be after start time") if
      end_time < start_time

    errors.add(:end_time, "cannot be equal to start time") if
      end_time == start_time

    errors.add(:start_time, "| You have already created another treatment for this time today.") if
      Treatment.where(user_id: user_id, start_time: start_time).where.not(id: id).exists?
  end

  def no_overlapping_treatments
    today = Time.current.beginning_of_day
    tomorrow = Time.current.end_of_day

    overlapping_treatments = Treatment.where(user_id: user_id).where.not(id: id)
                                      .where("start_time BETWEEN ? AND ?", today, tomorrow)
                                      .where("start_time < ? AND end_time > ?", end_time, start_time)

    errors.add(:start_time, "The treatment period overlaps with another existing treatment.") if
      overlapping_treatments.exists?
  end
end
