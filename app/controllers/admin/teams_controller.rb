class Admin::TeamsController < AdminController
  include Pagination
  before_action :set_team, only: [:show, :update, :destroy]
  load_and_authorize_resource

  # skip_before_filter :require_admin!, only: [:index]

  def index
    @teams = Team.all.order(:name)
    if params[:all]
      json_response(TeamSerializer, @teams)
    else
      @teams_paginated = @teams.page(current_page, per_page).per(per_page)
      json_response(TeamSerializer, @teams_paginated, options(@teams))
    end
  end

  def show
    json_response(TeamSerializer, @team)
  end

  def create
    @team = Team.create!(team_params)
    json_response(TeamSerializer, @team)
  end

  def update
    @team.update!(team_params)
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