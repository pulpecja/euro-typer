class AdminController < ApplicationController
  include ExceptionHandler

  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message }, status: 403
  end

  def current_ability
    controller_namespace = self.class.name.split("::").first
    @current_ability ||= Ability.new(current_user, controller_namespace)
  end
end
