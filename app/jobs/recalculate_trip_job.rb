class RecalculateTripJob < ApplicationJob
  queue_as :default

  def perform
    # Fetch appointments of previous day
    previous_day_appointments = Appointment.where(start_time: 1.day.ago.beginning_of_day..1.day.ago.end_of_day)

    # For each appointment of the previous day, find related trips and recalculate
    previous_day_appointments.each do |appointment|
      # Check for trips where appointment was the start_appointment
      trip_as_start = Trip.find_by(start_appointment_id: appointment.id)
      recalculate_trip(trip_as_start) if trip_as_start

      # Check for trips where appointment was the end_appointment
      trip_as_end = Trip.find_by(end_appointment_id: appointment.id)
      recalculate_trip(trip_as_end) if trip_as_end
    end
  end

  def recalculate_trip(trip)
    # Recalculate driving distance and driving time.
    # This uses the methods from your Trip model.
    trip.calculate_driving_distance
    trip.calculate_driving_time

    # Save the changes to the trip.
    trip.save
  end
end
