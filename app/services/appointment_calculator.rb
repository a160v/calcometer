class AppointmentCalculator
  def initialize(appointments)
    @appointments = appointments
  end

  # Calculate the total distance using Trip model
  def calculate_total_distance
    distances = Trip.joins(:start_appointment)
                    .where(start_appointment: @appointments)
                    .pluck(:driving_distance)
    @total_distance = distances.sum
    return @total_distance.to_f.round(2)
  end


  # Calculate the total duration using Trip model
  def calculate_total_duration
    durations = Trip.joins(:start_appointment)
                    .where(start_appointment: @appointments)
                    .pluck(:driving_duration)
    @total_duration = durations.sum
    return @total_duration.round
  end

  private

  def calculate_totals
    distances = []
    durations = []

    @appointments.each_cons(2) do |appointment1, appointment2|
      # Check if a trip with the same start and end appointments already exists
      # trip = Trip.find_by(start_appointment_id: appointment1.id, end_appointment_id: appointment2.id)

      # If such a trip exists and its driving_distance is neither nil nor 0, skip the current iteration
      # next if trip && (trip.driving_distance == 0 || trip.driving_distance.nil?)

      # Create trip object
      trip = Trip.new(start_appointment: appointment1, end_appointment: appointment2)
      # Assign the values to the object
      distance, duration = trip.send(:calculate_driving_distance_and_duration)
      trip.driving_distance = distance
      trip.driving_duration = duration
      # Save the trip object
      trip.save
        # Rails.logger.error "Failed to save trip. Errors: #{trip.errors.full_messages.join(', ')}"

      # Add distance and durations to the total
      distances << distance if distance
      durations << duration if duration
    end

    [distances.sum, durations.sum]
  end
end
