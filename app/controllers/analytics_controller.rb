class AnalyticsController < ApplicationController
  before_action :set_dates, only: [:index]

  def index
    # Set default date to daily date
    date_service = SetDailyAppointments.new(current_user)
    @appointments = date_service.appointments

    # Get the start_date and end_date from params
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.today

    # Fetch distance and duration for the given date range
    @total_distance, @total_duration = Trip.calculate_total_distance_and_duration(@start_date, @end_date)
  end


  private

  def set_dates
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Time.current.beginning_of_day
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Time.current.end_of_day
  end
end
