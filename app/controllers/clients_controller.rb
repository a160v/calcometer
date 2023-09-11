class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]

  def index
    @clients = Client.all.order("created_at DESC")
  end

  def show
  end

  def new
    @client = Client.new
  end

  def edit
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      current_user.update(client: @client) # Associate current user with the new client
      redirect_to root_path, notice: 'Client created successfully.'
    else
      render :new
    end
  end

  def update
    if @client.update(client_params)
      redirect_to clients_path, notice: 'Client was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path, notice: 'Client was successfully deleted.'
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :subdomain, :email, :user_id)
  end
end
