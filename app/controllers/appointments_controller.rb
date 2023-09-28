class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[show destroy]

  def index
    # Get the start_date and end_date from params
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.today

    # Fetch selected appointments and trips based on the given dates
    fetch_appointments_and_trips

    # Calculate total distance and duration using the Trip model's method
    @total_distance, @total_duration = Trip.calculate_total_distance_and_duration(@start_date, @end_date)
  end

  def daily_index
    # Set the start_date and end_date to today
    @start_date = Date.today
    @end_date = Date.today
    fetch_appointments_and_trips
  end

  def show
  end

  def new
    @appointment = Appointment.new
  end

  # Create a new appointment with user_id = current_user.id
  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.user = current_user
    @appointment.address_id = @appointment.patient.address_id

    if @appointment.save
      redirect_to daily_index_appointments_path, notice: t(:appointment_created_success)
    else
      render :new
    end
  end

  def destroy
    @appointment.destroy
    redirect_to daily_index_appointments_path, notice: t(:appointment_deleted_success)
  end

  def calculate_distance_and_duration
    # Check if existing trips exist in the db, then display them
    trip_service = SetDailyTrips.new(current_user)
    @trip = trip_service.trips

    # Calculate distances for all appointments of the current user for the day
    date_service = SetDailyAppointments.new(current_user)
    @appointments = date_service.appointments

    trips_service = TripCalculator.new(@appointments)
    driving_distance, driving_duration = trips_service.call
    render json: { driving_distance:, driving_duration: }
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def set_dates
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Time.current.beginning_of_day
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Time.current.end_of_day
  end

  def fetch_appointments_and_trips
    @appointments = SetDailyAppointments.new(current_user, @start_date, @end_date).appointments
    @trips = SetDailyTrips.new(current_user, @start_date, @end_date).trips

    # Since the date range is only for today, we can directly assign driving_distance
    @driving_distance = @trips.first&.driving_distance if @trips.any?
  end

  def appointment_params
    params.require(:appointment).permit(:user_id, :patient_id, :start_time, :end_time)
  end
end
