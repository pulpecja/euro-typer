class Admin::TeamsController < AdminController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # skip_before_filter :require_admin!, only: [:index]

  def index
    @teams = Team.all.order(:name)
    json_response(TeamSerializer, @teams)
  end

  def show
    json_response(TeamSerializer, @team)
  end

  def create
    @team = Team.create(team_params)
    json_response(TeamSerializer, @team)
  end

  def update
    @team.update(team_params)
    json_response(TeamSerializer, @team)
  end

  def destroy
    @team.destroy
    head :no_content
  end

  private
  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:data).permit(
      attributes: [
        :name,
        :abbreviation,
        :flag,
        :photo,
        :name_en
      ]
    )
  end
end