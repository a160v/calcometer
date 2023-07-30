class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

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

  # Set the locale of the current user and persist it in the database
  def set_locale
    if current_user && params[:locale].present? && I18n.available_locales.include?(params[:locale].to_sym)
      current_user.update(locale: params[:locale])
    end

    I18n.locale = current_user&.locale || params[:locale] || I18n.default_locale
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :last_name, :email, :time_zone, :locale, :password) }

    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :last_name, :email, :time_zone, :locale, :password, :current_password) }
  end
end
