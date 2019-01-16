class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  load_and_authorize_resource

  def index
    @users = User.all.order(:username)
    json_response(UserSerializer, @users)
  end

  def show
    json_response(UserSerializer, @user)
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  # Temp fix, need to be removed bc there is rescue in ApplicationController,
  # but seems not to be working
  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message }, status: 403
  end
end
