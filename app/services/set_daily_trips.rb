class SetDailyTrips
  def initialize(user, start_date = Time.current.beginning_of_day, end_date = Time.current.end_of_day)
    @user = user
    @start_date = start_date
    @end_date = end_date
  end

  def trips
    # Display only today's trips, sorted chronologically
    @trips ||= Trip.where(user_id: @user.id)
                   .where(created_at: @start_date..@end_date)
                   .includes(:user)
  end
end
