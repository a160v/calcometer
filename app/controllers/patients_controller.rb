class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  def index
    @patients = Patient.all
  end

  def show
  end

  def new
    @patient = Patient.new
  end

  def edit
  end

  def create
    @patient = Patient.new(patient_params)

    if @patient.save
      redirect_to patients_path, notice: 'Patient was successfully created.'
    else
      render :new
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

  # Render patient address in json format for Stimulus API call to Mapbox.
  def address
    patient = Patient.find(params[:id])
    render plain: patient.address
  end

  def next_patient_address
    patient = Patient.find(params[:id])
    next_patient = Patient.where('id > ?', patient.id).first
    next_patient = Patient.first if next_patient.nil? # Wrap around to the first patient if at the end of the list

    render plain: next_patient.address
  end

  private

    def set_patient
      @patient = Patient.find(params[:id])
    end

    def patient_params
      params.require(:patient).permit(:name, :address, :client_id)
    end
end
