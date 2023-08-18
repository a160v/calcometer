class Patient < ApplicationRecord
  # Model associations
  belongs_to :client
  belongs_to :address
  has_many :appointments, dependent: :nullify

  # Validations
  validates :name, :client, presence: true
  strip_attributes

  # accepts nested attributes
  accepts_nested_attributes_for :address
end
