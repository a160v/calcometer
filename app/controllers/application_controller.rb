class ApplicationController < ActionController::Base
  # Require login
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  # Validations
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_user_time_zone

  # Make browser_time_zone method available to all views
  helper_method :user_time_zone

  def set_user_time_zone
    Time.zone = current_user.time_zone if user_signed_in?
  end

  def user_time_zone
    user_signed_in? ? current_user.time_zone : 'Europe/Zurich'
  end

  def default_url_options
    { locale: I18n.locale }
  end

  # Set the locale upon log in
  def set_locale
    I18n.locale = current_user&.locale || params[:locale] || I18n.default_locale
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email, :time_zone, :locale, :password)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :email, :time_zone, :locale, :password)
    end
  end
end
