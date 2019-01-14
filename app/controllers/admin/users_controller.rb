class Admin::UsersController < AdminController
  load_and_authorize_resource

  def index
    if params[:filter].present? && params[:filter][:deleted_users]
      @deleted_users = User.deleted
      json_response(UserSerializer, @deleted_users)
    else
      @users = User.existing
      json_response(UserSerializer, @users)
    end
  end

  def show
    json_response(UserSerializer, @user)
  end

  def create
    @user = User.create!(user_params)
    json_response(UserSerializer, @user)
  end

  def update
    @user.update!(user_params)
    json_response(UserSerializer, @user)
  end

  def destroy
    @user.destroy
    head :no_content
  end

  protected
    def user_params
      params.require(:data).permit(
        attributes: [
          :email,
          :password,
          :photo,
          :role,
          :take_part,
          :username,
          competition_ids: []
        ]
      )
    end
end
