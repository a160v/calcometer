class AppointmentCalculator
  def initialize(appointments)
    @appointments = appointments
    @total_driving_distance = 0
    @total_driving_time = 0
  end

  # Calculate the total distance using Trip model
  def calculate_total_distance
    @appointments.each_cons(2).map do |appointment1, appointment2|
      Trip.new(start_appointment: appointment1, end_appointment: appointment2).calculate_driving_distance
    end.compact.sum
  end

  # Calculate the total time using Trip model
  def calculate_total_time
    @appointments.each_cons(2).map do |appointment1, appointment2|
      Trip.new(start_appointment: appointment1, end_appointment: appointment2).calculate_driving_time
    end.compact.sum
  end
end
