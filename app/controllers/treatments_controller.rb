class TreatmentsController < ApplicationController
  before_action :set_treatment, only: [:show, :edit, :update, :destroy]

  def index
    @treatments = Treatment.where(user: current_user).where('DATE(start_time) = ?', Date.today)
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

  private

    def set_treatment
      @treatment = Treatment.find(params[:id])
    end

    def treatment_params
      params.require(:treatment).permit(:user_id, :patient_id, :start_time, :end_time)
    end
end
