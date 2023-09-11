class Client < ApplicationRecord
  has_many :patients, dependent: :nullify
  has_many :users

  validates :name, presence: true
  validates :subdomain, presence: true
  validates :email,
            presence: true,
            format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ },
            on: :create,
            uniqueness: true

  strip_attributes
end
