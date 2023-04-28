class Patient < ApplicationRecord
  has_many :treatments
  belongs_to :client
  validates :address, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
