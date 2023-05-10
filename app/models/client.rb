class Client < ApplicationRecord
  has_many :patients, dependent: :nullify

  validates :name, :email, presence: true
  validates :email, uniqueness: { scope: :email, message: "already used by a client, please input a different one." }
end
