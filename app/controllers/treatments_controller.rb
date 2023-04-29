class TreatmentsController < ApplicationController
  before_action :set_treatment, only: [:show, :edit, :update, :destroy]

  #CRUD#########################################################################

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

  #GEOCODING####################################################################

  def daily_distance
    user = User.find(params[:user_id])
    date = params[:date].to_date
    treatments = user.treatments.where("DATE(start_time) = ?", date).limit(24)

    @total_distance = 0
    treatments.each_cons(2) do |treatment1, treatment2|
      distance = calculate_distance(treatment1.patient.address, treatment2.patient.address)
      total_distance += distance
    end
    return @total_distance
  end

  def daily_driving_time
    user = User.find(params[:user_id])
    date = params[:date].to_date
    treatments = user.treatments.where("DATE(start_time) = ?", date).limit(24)

    @total_time = 0
    treatments.each_cons(2) do |treatment1, treatment2|
      time = calculate_driving_time(treatment1.patient.address, treatment2.patient.address)
      total_time += time
    end
    @total_time
  end

  # Calculate distance between two addresses using Mapbox API
  def calculate_distance(address1, address2)
    coordinates1 = geocode(address1)
    coordinates2 = geocode(address2)

    # Calculate driving time and distance using Mapbox Directions API
    access_token = ENV['MAPBOX_API_KEY']
    base_url = "https://api.mapbox.com/directions/v5/mapbox/driving"
    coordinates_string = "#{coordinates1[:lon]},#{coordinates1[:lat]};#{coordinates2[:lon]},#{coordinates2[:lat]}"
    query_params = {
      access_token: access_token,
      geometries: "geojson"
    }

    url = "#{base_url}/#{coordinates_string}"
    response = HTTParty.get(url, query: query_params)
    json_response = JSON.parse(response.body)

    if json_response['routes'].empty?
      raise "Route not found between addresses: #{address1}, #{address2}"
    end

    distance = json_response['routes'].first['distance'] / 1000.0
    distance
  end

  # Calculate driving time between two addresses using Mapbox API
  def calculate_driving_time(address1, address2)
    coordinates1 = geocode(address1)
    coordinates2 = geocode(address2)

    # Calculate driving time and distance using Mapbox Directions API
    access_token = ENV['MAPBOX_API_KEY']
    base_url = "https://api.mapbox.com/directions/v5/mapbox/driving"
    coordinates_string = "#{coordinates1[:lon]},#{coordinates1[:lat]};#{coordinates2[:lon]},#{coordinates2[:lat]}"
    query_params = {
      access_token: access_token,
      geometries: "geojson"
    }

    url = "#{base_url}/#{coordinates_string}"
    response = HTTParty.get(url, query: query_params)
    json_response = JSON
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
