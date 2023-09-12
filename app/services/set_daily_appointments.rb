class SetDailyAppointments
  def initialize(user, start_date = Time.current.beginning_of_day, end_date = Time.current.end_of_day)
    @user = user
    @start_date = start_date
    @end_date = end_date
  end

  def appointments
    # Display only today's appointments, sorted chronologically
    @appointments ||= Appointment.where(user_id: @user.id)
                                 .where("start_time >= ? AND end_time <= ?", @start_date, @end_date)
                                 .includes(:patient)
  end
end
