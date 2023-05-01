 class TreatmentsController < ApplicationController
  before_action :set_treatment, only: [:show, :edit, :update, :destroy]

  #CRUD#########################################################################

  def index
    today = Time.current.beginning_of_day
    tomorrow = Time.current.end_of_day

    @treatments = Treatment.where(user_id: current_user.id).where("start_time >= ? AND end_time <= ?", today, tomorrow)

  end


  def show
  end

  def new
    @treatment = Treatment.new
  end

  def edit
  end

  def create
    @treatment = Treatment.new(treatment_params)
    @treatment.user = current_user

    if @treatment.save
      redirect_to treatments_path, notice: 'Treatment was successfully created.'
    else
      render :new
    end
  end

  def update
    if @treatment.update(treatment_params)
      redirect_to treatments_path, notice: 'Treatment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @treatment.destroy
    redirect_to treatments_path, notice: 'Treatment was successfully destroyed.'
  end

  ##Render patient address in json format for Stimulus API call to Mapbox.######
  def address
    patient_id = @treatment.patient_id
    patient = Patient.find(patient_id)
    address = patient.address
    render plain: patient_id
  end

  def previous_address
    patient = Patient.find(params[:id])
    previous_patient = Patient.where('id > ?', patient.id).first
    previous_patient = Patient.first if previous_patient.nil? # Wrap around to the first patient if at the end of the list

    render plain: previous_patient.address
  end
  #PRIVATE######################################################################

  private

    def set_treatment
      @treatment = Treatment.find(params[:id])
    end

    def treatment_params
      params.require(:treatment).permit(:user_id, :patient_id, :start_time, :end_time)
    end

end
