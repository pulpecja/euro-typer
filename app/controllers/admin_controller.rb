class AdminController < ApplicationController
  include ExceptionHandler

  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message }, status: 403
  end
end
