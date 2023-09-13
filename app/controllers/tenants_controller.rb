class TenantsController < ApplicationController
  before_action :set_tenant, only: %i[show edit update destroy]
  before_action :authorize_member!, only: %i[show edit update destroy]

  def index
    @tenants = current_user.tenant.order("created_at DESC")
  end

  def show
  end

  def new
    @tenant = Tenant.new
  end

  def edit
  end

  def create
    @tenant = Tenant.new(tenant_params)
    if @tenant.save
      @tenant.members.create(user: current_user, roles: { admin: true })
      redirect_to tenants_path, notice: t(:tenant_created_success)
    else
      render :new
    end
  end

  def update
    if @tenant.update(tenant_params)
      redirect_to tenants_path, notice: t(:tenant_updated_success)
    else
      render :edit
    end
  end

  def destroy
    @tenant.destroy
    redirect_to tenants_path, notice: t(:tenant_deleted_success)
    puts @tenant.inspect
  end

  private

  def authorize_member!
    return redirect_to root_path, alert: 'You are not a member' unless @tenant.users.include? current_user
  end

  def set_tenant
    @tenant = Tenant.find(params[:id])
  end

  def tenant_params
    params.require(:tenant).permit(:name, :email)
  end
end
