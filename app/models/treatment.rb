class Treatment < ApplicationRecord
  belongs_to :user
  belongs_to :patient
  has_many :addresses, through: :patients

  validates :start_time, :end_time, presence: true
  # validate :end_time_different_start_time, :start_time_unique
  validate :validate_time

  def validate_time
    errors.add(:end_time, "is not consistent with the start time") if
      end_time <= start_time

    errors.add(:start_time, message: "| You have already created another treatment for this time today.") if
      Treatment.where(user_id: user_id, start_time: start_time).where.not(id: id).exists?
  end
end
