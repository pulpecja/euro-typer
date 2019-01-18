class WinnerTypesController < ApplicationController
  before_action :set_winner_type, only: [:show, :update, :destroy]
  load_and_authorize_resource

  def index
    @winner_types = WinnerType.all.by_competition(params[:filter][:competition_id])
    json_response(WinnerTypeSerializer, @winner_types)
  end

  def show
    json_response(WinnerTypeSerializer, @winner_type)
  end

  def create
    @winner_type = WinnerType.create!(winner_type_params)
    json_response(WinnerTypeSerializer, @winner_type)
  end

  def update
    @winner_type.update!(winner_type_params)
    json_response(WinnerTypeSerializer, @winner_type)
  end

  def destroy
    @winner_type.destroy
    head :no_content
  end

  private
  def set_winner_type
    @winner_type = WinnerType.find(params[:id])
  end

  def winner_type_params
    params.require(:data).permit(
      attributes: [
        :team_id,
        :competition_id,
        :user_id
      ]
    )
  end

  # Temp fix, need to be removed bc there is rescue in ApplicationController,
  # but seems not to be working
  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message }, status: 403
  end
end