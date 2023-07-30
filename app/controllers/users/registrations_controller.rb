class Users::RegistrationsController < Devise::RegistrationsController
  protected

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
