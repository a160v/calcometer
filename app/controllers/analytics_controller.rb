class AnalyticsController < ApplicationController
  include TreatmentsHelper
  before_action :set_dates, only: [:index]

  # Display only today's treatments, sorted chronologically
  def index
    set_dates_to_today
    set_time_and_distance_to_zero

    # Calculate total distance and time starting from the first treatment
    # if there are more than two treatments
    return unless @treatments.length >= 2

    @treatments.each_cons(2) do |treatment1, treatment2|
      @total_distance += calculate_distance(treatment1.patient.address, treatment2.patient.address)
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

    @treatments = Treatment.joins(:patient)
                           .where(user_id: current_user.id)
                           .where("start_time >= ? AND start_time <= ?",
                            @start_date.beginning_of_day, @end_date.end_of_day)
  end

  def set_time_and_distance_to_zero
    @total_distance = 0
    @total_time = 0
  end
end
