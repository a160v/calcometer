class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Use the jstz Javascript timezone library to help auto-detect and set the user's time zone
  def browser_time_zone
    browser_tz = ActiveSupport::TimeZone.find_tzinfo(cookies[:timezone])
    ActiveSupport::TimeZone.all.find { |zone| zone.tzinfo == browser_tz } || Time.zone
    # Rescue two exceptions thrown by browser_tz
  rescue TZInfo::UnknownTimezone, TZInfo::InvalidTimezoneIdentifier
    # Else return the default time zone (UTC)
    Time.zone
  end

  # Make browser_time_zone method available to all views
  helper_method :browser_time_zone

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :last_name, :email, :time_zone, :password) }

    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :last_name, :email, :time_zone, :password, :current_password) }
  end
end
