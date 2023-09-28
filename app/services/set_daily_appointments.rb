class SetDailyAppointments
  def initialize(user, start_date = Time.current.beginning_of_day, end_date = Time.current.end_of_day)
    @user = user
    @start_date = start_date
    @end_date = end_date
  end

  def appointments
    # Display only today's appointments, sorted chronologically
    @appointments ||= Appointment.where(user_id: @user.id)
                                 .where("start_time < ? AND end_time > ?", @end_date.end_of_day, @start_date.beginning_of_day)
                                 .includes([:patient])
                                 .order(:start_time)
  end
end
