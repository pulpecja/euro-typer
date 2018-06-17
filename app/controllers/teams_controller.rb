class TeamsController < ApplicationController
  before_action :set_team, only: [:show]
  load_and_authorize_resource

  def show
    @matches = Match.by_team(@team)
                    .includes(:first_team, :second_team, :round)
                    .group_by(&:competition)
                    .sort_by{|k, v| k}.reverse
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name)
    end
end
