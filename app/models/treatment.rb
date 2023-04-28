class Treatment < ApplicationRecord
  belongs_to :user
  belongs_to :patient
  validates :start_time, :end_time, presence: true
end
