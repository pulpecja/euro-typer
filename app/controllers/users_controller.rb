class UsersController < ApplicationController
  load_and_authorize_resource except: [:join_competition]
  skip_authorization_check only: [:join_competition]

  def show
    @user = User.find(params[:id])
  end

  def join_competition
    @user = User.find(params[:user_id])
    @competition = Competition.find(params[:competition_id])

    @user.competitions << @competition

    if @user.save
      flash[:notice] = "Pomyślnie dodano do turnieju #{@competition.name}!"
      redirect_to :back
    else
      flash[:notice] = "Nie udało się dodać do turnieju."
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :email)
  end
end
