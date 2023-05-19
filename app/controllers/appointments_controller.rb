class AppointmentsController < ApplicationController
  include AppointmentsHelper
  before_action :set_appointment, only: %i[show edit update destroy]

  # Display only today's appointments, sorted chronologically
  def index
    today = Time.current.beginning_of_day
    tomorrow = Time.current.end_of_day

    @appointments = Appointment.where(user_id: current_user.id).where("start_time >= ? AND end_time <= ?", today, tomorrow).includes(:patient)
    @total_distance = 0
    @total_time = 0

    # Calculate total distance and time starting from the first appointment
    # if there are more than two appointments
    return unless @appointments.length >= 2

    @appointments.each_cons(2) do |appointment1, appointment2|
      if appointment1.patient.present? && appointment2.patient.present?
        @total_distance += calculate_distance(appointment1.patient.address, appointment2.patient.address)
      end
    end
    @total_time = calculate_driving_time(@total_distance)
  end

  # CRUD ########################################################################

  def show
  end

  def new
    @appointment = Appointment.new
  end

  def edit
  end

  # Create a new appointment with user_id = current_user.id
  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.user = current_user

    if @appointment.save
      redirect_to appointments_path, notice: 'Appointment was successfully created.'
    else
      # Render in HTML and JSON with error messages
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { errors: @appointment.errors[:base] }, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to appointments_path, notice: 'Appointment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @appointment.destroy
    redirect_to appointments_path, notice: 'Appointment was successfully deleted.'
  end

  # PRIVATE ####################################################################

  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.requAre(:appointment).permit(:user_id, :patient_id, :start_time, :end_time)
  end
end
