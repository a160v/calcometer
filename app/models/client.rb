class Client < ApplicationRecord
  # Leaving the door open for invitation
  has_many :users, dependent: :nullify
  has_many :patients, dependent: :nullify
  has_many :appointments, through: :patients, dependent: :nullify

  validates :name, presence: true
  validates :subdomain, presence: false

  strip_attributes
end
