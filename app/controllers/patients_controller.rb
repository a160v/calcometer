class PatientsController < ApplicationController
  before_action :set_patient, only: %i[show edit update destroy]

  def index
    @patients = Patient.all
  end

  def show
    @total_time_spent_with_patient = total_time_spent_with_patient
  end

  def new
    @patient = Patient.new
    @patient.build_address
  end

  def edit
  end

  def create
    @address = Address.find_or_create_by(patient_params[:address_attributes])
    Rails.logger.debug @address.inspect
    @patient = Patient.new(patient_params)
    @patient.address = @address

    if @patient.save
      redirect_to patients_path, notice: 'Patient was successfully created.'
    else
      Rails.logger.debug @patient.errors.full_messages
      @address.errors.add(:base, "Geocoding failed. Please check the address.")
      flash.now[:error] = @address.errors.full_messages.join(", ")
      # Render in HTML and JSON with error messages
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { errors: @patient.errors[:base] }, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @patient.update(patient_params)
      redirect_to patients_path, notice: 'Patient was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @patient.destroy
    redirect_to patients_path, notice: 'Patient was successfully deleted.'
  end

  def total_time_spent_with_patient
    total_minutes = @patient.appointments.sum { |appointment| (appointment.end_time - appointment.start_time) / 60 }
    "%d:%02d" % [total_minutes / 60, total_minutes % 60]
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:name, :client_id, address_attributes: %i[street number zip_code city state country])
  end
end
