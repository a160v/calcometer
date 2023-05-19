class AnalyticsController < ApplicationController
  include AppointmentsHelper
  before_action :set_dates, only: [:index]

  # Display only today's appointments, sorted chronologically
  def index
    set_dates_to_today
    set_time_and_distance_to_zero

    # Calculate total distance and time starting from the first appointment
    # if there are more than two appointments
    return unless @appointments.length >= 2

    @appointments.each_cons(2) do |appointment1, appointment2|
      @total_distance += calculate_distance(appointment1.patient.address, appointment2.patient.address)
    end

    @total_time = calculate_driving_time(@total_distance)
  end

  private

  # Set the start and end dates to today's date
  def set_dates
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Time.current.beginning_of_day
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Time.current.end_of_day
  end

  def set_dates_to_today
    @start_date = params[:start_date]&.to_date || Time.current.to_date
    @end_date = params[:end_date]&.to_date || Time.current.to_date

    @appointments = Appointment.joins(:patient)
                           .where(user_id: current_user.id)
                           .where("start_time >= ? AND start_time <= ?",
                            @start_date.beginning_of_day, @end_date.end_of_day)
  end

  def set_time_and_distance_to_zero
    @total_distance = 0
    @total_time = 0
  end
end
