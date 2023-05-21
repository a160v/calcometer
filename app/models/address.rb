class Address < ApplicationRecord
  # Model associations
  has_many :patients
  has_many :users

  # Validations
  validates :street, :number, :zip_code, :city, :state, :country, presence: true
  validate :found_address_presence

  # Callbacks
  before_save :geocode, if: :address_changed?

  # Method to concatenate full address
  def full_address
    [street, number, zip_code, city, state, country].compact.join(', ')
  end

  # Method to check if any part of the address has changed
  def address_changed?
    street_changed? || number_changed? || zip_code_changed? || city_changed? || state_changed? || country_changed?
  end

  private

  # Callback method to geocode address
  def geocode
    geo = Geocoder.search(full_address).first
    if geo.present?
      self.latitude, self.longitude = geo.coordinates
    else
      errors.add(:address, "wasn't found.")
    end
  end

  # Validation method to check if the address is geocoded
  def found_address_presence
    return unless latitude.blank? || longitude.blank?

    errors.add(:address, "wasn't found.")
  end
end
