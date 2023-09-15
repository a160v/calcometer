class Patient < ApplicationRecord
  # Model associations
  belongs_to :address
  has_many :appointments, dependent: :nullify

  # Validations
  validates :name, presence: true
  strip_attributes

  # accepts nested attributes
  accepts_nested_attributes_for :address
end
