class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # Associations
  has_many :appointments, dependent: :nullify
  has_many :trips, dependent: :nullify

  # Validations
  validates :email, uniqueness: true

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    user ||= User.create(
      first_name: data['first_name'],
      last_name: data['last_name'],
      time_zone: "Zurich",
      locale: "it",
      email: data['email'],
      password: Devise.friendly_token[0, 20]
    )
    user
  end
end
