class Patient < ApplicationRecord
  has_many :treatments, dependent: :nullify
  belongs_to :client
  validates :address, :name, :client, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
