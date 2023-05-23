class Client < ApplicationRecord
  has_many :patients, dependent: :nullify

  validates :name, presence: true
  validates :email,
            presence: true,
            format: {
              with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/,
              message: 'Please provide a valid e-mail address'
            },
            on: :create,
            uniqueness: { message: "already used by an existing client, please provide a different one." }
end
