class Users::RegistrationsController < Devise::RegistrationsController

  protected

  def after_sign_up_path_for(resource)
    new_tenant_path # Redirect them to new tenant path, you can change this as per your setup
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # The user can update the locale and persist it in the database
  def update_locale
    if current_user && params[:locale].present? && I18n.available_locales.include?(params[:locale].to_sym)
      current_user.update(locale: params[:locale])
    end
    redirect_to root_path(locale: params[:locale])
  end

end
