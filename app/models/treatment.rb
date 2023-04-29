class Treatment < ApplicationRecord
  belongs_to :user
  belongs_to :patient
  has_many :addresses, through: :patients

  validates :start_time, :end_time, presence: true
end
