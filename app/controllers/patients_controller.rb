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
    @patient = build_patient
    find_or_build_address

    respond_to do |format|
      save_patient(format)
    end
  end

  def update
    if @patient.update(patient_params)
      redirect_to patients_path, notice: t(:patient_updated_success)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.destroy
    redirect_to patients_path, notice: t(:patient_deleted_success)
  end

  def total_time_spent_with_patient
    total_minutes = @patient.appointments.sum { |appointment| (appointment.end_time - appointment.start_time) / 60 }
    format("%d:%02d", total_minutes / 60, total_minutes % 60)
  end

  private

  def build_patient
    Patient.new(patient_params.except(:address_attributes))
  end

  def find_or_build_address
    address_attributes = patient_params[:address_attributes]
    @address = Address.find_by(address_attributes)

    if @address.nil?
      build_address(address_attributes)
    else
      set_address
    end
  end

  def build_address(address_attributes)
    @patient.build_address(address_attributes)
  end

  def set_address
    @patient.address = @address
  end

  def save_patient(format)
    if @patient.save
      format.html { redirect_to patients_path, notice: t(:patient_created_success) }
    else
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@patient, partial: 'form', locals: { patient: @patient })
      end
      format.html { render :new }
    end
  end

  def set_patient
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:name, address_attributes: %i[street number zip_code city state country])
  end
end
