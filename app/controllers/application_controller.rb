class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }

  before_action :authenticate_user!, except: [:new, :create]

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  # before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :role])
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  # end
end