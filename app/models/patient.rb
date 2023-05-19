class Patient < ApplicationRecord
  belongs_to :client
  belongs_to :address

  validates :name, :client, :address, presence: true

  has_many :appointments, dependent: :nullify
end
