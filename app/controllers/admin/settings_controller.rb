class Admin::SettingsController < AdminController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @settings = Setting.all
  end

  def show
  end

  def new
    @setting = Setting.new
  end

  def edit
  end

  def create
    @setting = Setting.new(setting_params)

    if @setting.save
      flash[:notice] = "Ustawienia stworzone"
      redirect_to(admin_settings_path)
    else
      flash[:error]  = "Nie udało się utworzyć ustawień"
      render action: 'new'
    end
  end

  def update
    if @setting.update(setting_params)
      flash[:notice] = "Ustawienia zapisane"
      redirect_to(admin_settings_path)
    else
      flash[:error]  = "Nie udało się wyedytować ustawień."
      render action: 'edit'
    end
  end

  def destroy
    @setting.destroy
    flash[:notice] = 'Ustawienia usunięte!'
    redirect_to admin_settings_path
  end

  private
    def set_setting
      @setting = Setting.find(params[:id])
    end

    def setting_params
      params.require(:setting).permit(:name, :value)
    end
end
