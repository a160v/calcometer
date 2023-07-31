class Address < ApplicationRecord
  # Model associations
  has_many :patients
  has_many :users

  # Validations
  validates :street, :number, :zip_code, :city, :state, :country, presence: { message: "This field is required" }
  validate :found_address_presence

  # Callbacks
  before_validation :geocode, if: :address_changed?
  geocoded_by :full_address

  # Validation method to check if the address is geocoded
  def found_address_presence
    return unless latitude.blank? || longitude.blank?

    errors.add(:address, "wasn't found.")
  end

  # Method to concatenate full address
  def full_address
    [street, number, zip_code, city, state, country].compact.join(', ')
  end

  # Method to concatenate a nice address to show to the user
  def nice_address
    street_number = [street, number].compact.join(' ')
    zip_city = [zip_code, city].compact.join(' ')
    return [street_number, zip_city].compact.join(', ')
  end

  # Method to check if any part of the address has changed
  def address_changed?
    street_changed? || number_changed? || zip_code_changed? || city_changed? || state_changed? || country_changed?
  end

  # Callback method to geocode address
  def geocode
    Rails.logger.debug "Geocoding address: #{full_address}"
    geo = Geocoder.search(full_address).first
    Rails.logger.debug "Geocoder result: #{geo.inspect}"
    if geo.present?
      self.latitude = geo.latitude
      self.longitude = geo.longitude
    else
      errors.add(:street, "Geocoding failed. Please check the address.")
    end
  end
end
