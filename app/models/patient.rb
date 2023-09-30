class Patient < ApplicationRecord
  # Model associations
  belongs_to :address
  has_many :appointments, dependent: :nullify

  # Validations
  validates :name, presence: true
  strip_attributes

  # Accepts nested attributes
  accepts_nested_attributes_for :address

  # Encryption
  encrypts :name, deterministic: true # is deterministic so it can be queuered
end
