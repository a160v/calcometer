class TreatmentsController < ApplicationController
  before_action :set_treatment, only: [:show, :edit, :update, :destroy]

  def index
    today = Time.current.beginning_of_day
    tomorrow = Time.current.end_of_day

    @treatments = Treatment.where(user_id: current_user.id).where("start_time >= ? AND end_time <= ?", today, tomorrow)
    @total_distance = 0
    @total_time = 0

    if @treatments.length >= 2
      @treatments.each_cons(2) do |treatment1, treatment2|
        @total_distance += calculate_distance(treatment1.patient.address, treatment2.patient.address)
      end
      @total_time = calculate_driving_time(@total_distance)
    end
  end

  #CRUD#########################################################################

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
      flash.now[:error] = @treatment.errors.full_messages.to_sentence
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

  # Fetch the total distance driven by car between each treatment;
  # reiterate with all treatments for a given day
  def calculate_distance(address1, address2)

    # Geocoding the addresses to get coordinates
    coordinates1 = Geocoder.coordinates(address1)
    coordinates2 = Geocoder.coordinates(address2)

    # Check if coordinates are available
    if coordinates1.nil? || coordinates2.nil?
      raise "Coordinates not found for one or both addresses: #{address1}, #{address2}"
    end

    # Calculate distance using Geocoder::Calculations.distance_between
    distance = Geocoder::Calculations.distance_between(coordinates1, coordinates2)

    return distance
  end

  def calculate_driving_time(distance)
    # Average driving speed in Switzerland (in km/h)
    average_speed = 50.0

    # Calculate driving time in hours
    time_in_hours = distance.round(2) / average_speed

    # Convert driving time to minutes
    time_in_minutes = (time_in_hours * 60).round

    return time_in_minutes
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
