class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Make browser_time_zone method available to all views
  helper_method :browser_time_zone

  # Use the jstz Javascript timezone library to help auto-detect and set the user's time zone
  def browser_time_zone
    browser_tz = ActiveSupport::TimeZone.find_tzinfo(cookies[:browser_time_zone])
    ActiveSupport::TimeZone.all.find { |zone| zone.tzinfo == browser_tz } || Time.zone
    # Rescue two exceptions thrown by browser_tz
  rescue TZInfo::UnknownTimezone, TZInfo::InvalidTimezoneIdentifier
    # Else return the default time zone (UTC)
    Time.zone
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
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :time_zone, :locale, :password) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :email, :time_zone, :locale, :password) }
  end
end
