class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in)        << :username
    devise_parameter_sanitizer.for(:sign_up)        << :username
    devise_parameter_sanitizer.for(:account_update) << :username
    devise_parameter_sanitizer.for(:sign_up)        << :role

  end
end