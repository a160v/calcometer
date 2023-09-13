class Tenant < ApplicationRecord
  # Leaving the door open for invitation
  has_many :members, dependent: :destroy
  has_many :users, through: :members
  has_many :patients, dependent: :nullify
  has_many :appointments, through: :patients, dependent: :nullify

  # Validations
  validates :name, presence: true

  strip_attributes
end
