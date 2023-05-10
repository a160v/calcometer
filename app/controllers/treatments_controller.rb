class TreatmentsController < ApplicationController
  include TreatmentsHelper
  before_action :set_treatment, only: %i[show edit update destroy]

  # Display only today's treatments, sorted chronologically
  def index
    today = Time.current.beginning_of_day
    tomorrow = Time.current.end_of_day

    @treatments = Treatment.where(user_id: current_user.id).where("start_time >= ? AND end_time <= ?", today, tomorrow).includes(:patient)
    @total_distance = 0
    @total_time = 0

    # Calculate total distance and time starting from the first treatment
    # if there are more than two treatments
    return unless @treatments.length >= 2

    @treatments.each_cons(2) do |treatment1, treatment2|
      if treatment1.patient.present? && treatment2.patient.present?
        @total_distance += calculate_distance(treatment1.patient.address, treatment2.patient.address)
      end
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

  # Create a new treatment with user_id = current_user.id
  def create
    @treatment = Treatment.new(treatment_params)
    @treatment.user = current_user

    if @treatment.save
      redirect_to treatments_path, notice: 'Treatment was successfully created.'
    else
      # Render in HTML and JSON with error messages
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { errors: @treatment.errors[:base] }, status: :unprocessable_entity }
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
    redirect_to treatments_path, notice: 'Treatment was successfully deleted.'
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
