class Treatment < ApplicationRecord
  belongs_to :user
  belongs_to :patient
  has_many :addresses, through: :patients

  validates :start_time, :end_time, presence: true
  validate :end_time_after_start_time

  def end_time_after_start_time
    if end_time.present? && start_time.present? && end_time < start_time
      errors.add(:end_time, "End date must after the start date")
    end
  end
end
