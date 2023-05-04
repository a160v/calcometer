class TreatmentsController < ApplicationController
  include TreatmentsHelper
  before_action :set_treatment, only: %i[show edit update destroy]

  def index
    today = Time.current.beginning_of_day
    tomorrow = Time.current.end_of_day

    @treatments = Treatment.where(user_id: current_user.id).where("start_time >= ? AND end_time <= ?", today, tomorrow)
    @total_distance = 0
    @total_time = 0

    return unless @treatments.length >= 2

    @treatments.each_cons(2) do |treatment1, treatment2|
      @total_distance += calculate_distance(treatment1.patient.address, treatment2.patient.address)
    end
    @total_time = calculate_driving_time(@total_distance)
  end

  # CRUD ########################################################################

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
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { errors: @treatment.errors }, status: :unprocessable_entity }
      end
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

  # PRIVATE ####################################################################

  private

  def set_treatment
    @treatment = Treatment.find(params[:id])
  end

  def treatment_params
    params.require(:treatment).permit(:user_id, :patient_id, :start_time, :end_time)
  end
end
