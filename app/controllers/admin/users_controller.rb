class Admin::UsersController < AdminController
  load_and_authorize_resource

  # skip_before_filter :require_admin!, only: [:index]

  def index
    @users = User.existing
    @deleted_users = User.deleted
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Użytkownik stworzony"
      redirect_to(admin_users_path(@user))
    else
      flash[:error]  = "Nie udało się utworzyć użytkownika."
      render action: 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash.now[:notice] = "Użytkownik zapisany."
      redirect_to admin_users_path
    else
      flash[:error]  = "Nie udało się wyedytować użytkownika."
      render action: 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute(:deleted_at, Time.now)
      flash[:notice] = 'Użytkownik usunięty!'
    else
      flash[:error] = 'Użytkownik nie może zostać usunięty!'
    end
    redirect_to admin_users_path
  end

  protected

    def user_params
      params.require(:user).permit(:username, :email, :role, :take_part)
    end

end
