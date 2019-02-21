class Admin::TeamsController < AdminController
  before_action :set_team, only: [:show, :update, :destroy]
  load_and_authorize_resource

  # skip_before_filter :require_admin!, only: [:index]

  def index
    @teams = Team.all.order(:name)
    if params[:all]
      json_response(TeamSerializer, @teams)
    else
      @teams_paginated = @teams.page(current_page, per_page).per(per_page)
      options = {
        links: {
          first: admin_teams_path(per_page: per_page),
          self: admin_teams_path(page: current_page, per_page: per_page),
          last: admin_teams_path(page: total_pages, per_page: per_page)
        }
      }
      json_response(TeamSerializer, @teams_paginated, options)
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

  def current_page
    (params[:page] || 1).to_i
  end
  
  def per_page
    (params[:per_page] || 20).to_i
  end

  def total_pages
    ((@teams.size.to_f / per_page.to_f).ceil || 1).ceil.to_i
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