class TeamsController < ApplicationController
  before_action :set_team, only: [:show]
  load_and_authorize_resource

  def index
    @teams = Team.all.order(:name)
    json_response(TeamSerializer, @teams)
  end

  def show
    json_response(TeamSerializer, @team)
  end

  private
  def set_team
    @team = Team.find(params[:id])
  end

  # Temp fix, need to be removed bc there is rescue in ApplicationController,
  # but seems not to be working
  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message }, status: 403
  end
end
