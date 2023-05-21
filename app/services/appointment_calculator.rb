class AppointmentCalculator
  def initialize(appointments)
    @appointments = appointments
  end

  # Calculate the total distance and total time using Trip model
  def calculate_total_distance
    @appointments.each_cons(2).map do |appointment1, appointment2|
      Trip.new(start_appointment: appointment1, end_appointment: appointment2).calculate_driving_distance
    end.compact.sum
  end

  def calculate_total_time
    @appointments.each_cons(2).map do |appointment1, appointment2|
      Trip.new(start_appointment: appointment1, end_appointment: appointment2).calculate_driving_time
    end.compact.sum
  end
end
