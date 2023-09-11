class Patient < ApplicationRecord
  # Model associations
  acts_as_tenant :client
  belongs_to :address
  has_many :appointments, dependent: :nullify

  # Validations
  validates :name, :client, presence: true
  strip_attributes

  # accepts nested attributes
  accepts_nested_attributes_for :address
end
