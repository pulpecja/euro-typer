class Admin::SettingsController < AdminController
  before_action :set_setting, only: [:show, :update, :destroy]
  load_and_authorize_resource

  def index
    @settings = Setting.all
    json_response(SettingSerializer, @settings)
  end

  def show
    json_response(SettingSerializer, @setting)
  end

  def create
    @setting = Setting.create!(setting_params)
    json_response(SettingSerializer, @setting)
  end

  def update
    @setting.update!(setting_params)
    json_response(SettingSerializer, @setting)
  end

  def destroy
    @setting.destroy
    head :no_content
  end

  private
    def set_setting
      @setting = Setting.find(params[:id])
    end

  def setting_params
    params.require(:data).permit(
      attributes: [
        :name,
        :value
      ]
    )
  end
end
