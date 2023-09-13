class MembersController < ApplicationController
  before_action :set_current_tenant

  def index
    @members = @current_tenant.members
  end

  def invite
    email = params[:email]
    return redirect_to tenant_members_path(@current_tenant), alert: 'No email provided' if email.blank?

    user = User.find_by(email: email) || User.invite!({email: email}, current_user)
    return redirect_to tenant_members_path(@current_tenant), alert: 'Email invalid' unless user.valid?

    user.members.find_or_create_by(tenant: @current_tenant, roles: {admin: false, editor: true})
    # TODO: Email that user has been added to this workspace
    redirect_to tenant_members_path(@current_tenant), notice: "User #{email} has been invited."
  end

  private

  def set_current_tenant
    @current_tenant = Tenant.find(params[:tenant_id])
  end

end
