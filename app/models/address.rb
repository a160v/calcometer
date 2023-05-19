class Address < ApplicationRecord
  before_validation :geocode, if: :address_changed?

  validates :street, :number, :zip_code, :city, :state, :country, presence: true
  validate :found_address_presence

  has_many :patients
  has_many :users

  geocoded_by :full_address

  def found_address_presence
    return unless latitude.blank? || longitude.blank?

    errors.add(:address, "wasn't found.")
  end

  def full_address
    [street, number, zip_code, city, state, country].compact.join(', ')
  end

  private

  def address_changed?
    street_changed? || number_changed? || zip_code_changed? || city_changed? || state_changed? || country_changed?
  end
  
  def geocode
    geo = Geocoder.search(full_address).first
    if geo.present?
      self.latitude, self.longitude = geo.coordinates
    else
      puts "Warning: Could not geocode address: #{full_address}"
    end
  end
end
