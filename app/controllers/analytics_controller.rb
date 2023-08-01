class AnalyticsController < ApplicationController
  before_action :set_dates, only: [:index]

  def index
    # Enable user to select a date range
    set_dates_to_today

    start_date = params[:start_date]&.to_date || Time.current.to_date
    end_date = params[:end_date]&.to_date || Time.current.to_date
    service = AppointmentService.new(current_user, start_date.beginning_of_day, end_date.end_of_day)

    @appointments = service.appointments
    @total_distance = service.total_distance
    @total_time = service.total_time
  end

  private

  def set_dates
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Time.current.beginning_of_day
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Time.current.end_of_day
  end

  # Set the start and end dates to today's date
  def set_dates_to_today
    @start_date = params[:start_date]&.to_date || Time.current.to_date
    @end_date = params[:end_date]&.to_date || Time.current.to_date

    @appointments = Appointment.joins(:patient)
                               .where(user_id: current_user.id)
                               .where("start_time >= ? AND start_time <= ?", @start_date.beginning_of_day, @end_date.end_of_day)
  end
end
