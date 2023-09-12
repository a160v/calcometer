class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[show destroy]

  def index
    # Displays all appointments for current day
    date_service = SetDailyAppointments.new(current_user)
    @appointments = date_service.appointments
    # Displays all trips for current day
    trip_service = SetDailyTrips.new(current_user)
    @trip = trip_service.trips
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
    @appointment.client_id = @appointment.patient.client_id

    if @appointment.save
      redirect_to appointments_path, notice: t(:appointment_created_success)
    else
      # Render in HTML and JSON with error messages
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { errors: @appointment.errors[:base] }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @appointment.destroy
    redirect_to appointments_path, notice: t(:appointment_deleted_success)
  end

  def calculate_daily_driving_distance_and_duration_from_service
    # Check if existing trips exist in the db, then display them
    trip_service = SetDailyTrips.new(current_user)
    @trip = trip_service.trips

    # Calculate distances for all appointments of the current user for the day
    date_service = SetDailyAppointments.new(current_user)
    @appointments = date_service.appointments

    trips_service = TripCalculator.new(@appointments)
    driving_distance, driving_duration = trips_service.call
    render json: { driving_distance: driving_distance, driving_duration: driving_duration }
  end


  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:user_id, :patient_id, :start_time, :end_time)
  end
end
