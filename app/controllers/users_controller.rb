class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.all.existing.includes(types: :match).sort_by(&:points).reverse
  end

  def show
    @user = User.find(params[:id])
  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email)
    end
end
