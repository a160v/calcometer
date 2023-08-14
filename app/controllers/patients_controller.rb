class PatientsController < ApplicationController
  before_action :set_patient, only: %i[show edit update destroy]

  def index
    @patients = Patient.all.order("created_at DESC")
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
    @patient = Patient.new(patient_params)
    @address = Address.find_or_create_by(@patient.address.attributes)
    @patient.address = @address

    if @patient.save
      redirect_to patients_path, notice: 'Patient was successfully created.'
    else
      Rails.logger.debug @patient.errors.full_messages
      @address.errors.add(:base, "Geocoding failed. Please check the address.")
      @patient.build_address if @patient.address.nil?

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@patient, partial: 'form', locals: { patient: @patient }) }
        format.html { render :new }
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
