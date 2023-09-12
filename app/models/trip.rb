class Trip < ApplicationRecord
  # acts_as_tenant :client
  belongs_to :client
  belongs_to :user

  # Update a trip if it exists if 'created_at' is the same as today
  def self.save_or_update_trip(distance, duration)
    today = Date.today
    trip = Trip.find_by("DATE(created_at) = ?", today)

    if trip
      trip.update(distance: distance, duration: duration)
    else
      Trip.create(distance: distance, duration: duration)
    end
  end

  def self.calculate_total_distance_and_duration(start_date, end_date)
    # Fetch all trips between start_date and end_date
    trips = Trip.where(updated_at: start_date.beginning_of_day...end_date.end_of_day)
                .pluck(:driving_distance, :driving_duration)

    # Sum and return the values within the arrays
    total_distance = trips.map { |trip| trip[0] || 0 }.sum
    total_duration = trips.map { |trip| trip[1] || 0 }.sum

    [total_distance.round(2), total_duration.round]
  end

end
