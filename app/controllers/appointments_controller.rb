class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[show edit update destroy]

  # Display only today's appointments, sorted chronologically

  def index
    service = AppointmentService.new(current_user)
    @appointments = service.appointments
    @total_distance = service.total_distance
    @total_time = service.total_time
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
    params.require(:appointment).permit(:user_id, :patient_id, :start_time, :end_time)
  end
end
