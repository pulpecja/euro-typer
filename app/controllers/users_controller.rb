class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  # def update
  #   if @user.update_attributes(user_params)
  #     flash[:success] = "Successfully saved #{@user.username}"
  #     redirect_to root_url
  #   else
  #     flash[:danger] = "#{@user.errors.full_messages.to_sentence}."
  #     render :edit
  #   end
  # end

  private
  def user_params
    params.require(:user).permit(:username, :password, :email)
  end
end
