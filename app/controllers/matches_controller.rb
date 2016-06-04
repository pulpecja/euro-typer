class MatchesController < ApplicationController
  before_action :set_match, only: [:show]
  load_and_authorize_resource

  def index
    @round = params[:round] ? Round.find(params[:round]) : Round.all.first
    @matches = Match.includes(:first_team, :second_team).where(round_id: @round.id)
    @users = User.existing
  end

  def show
  end

  private
    def set_match
      @match = Match.find(params[:id])
    end

    def match_params
      params.require(:match).permit(:first_team_id, :second_team_id, :played, :first_score, :second_score, :round)
    end
end
