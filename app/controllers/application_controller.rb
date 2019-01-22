class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Response
  include ExceptionHandler

  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message }, status: 403
  end

  # before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :role])
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  # end
end