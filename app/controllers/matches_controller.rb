class MatchesController < ApplicationController
  before_action :set_match, only: [:show]
  load_and_authorize_resource

  def index
    @groups      = current_user.groups
    @group       = Group.find(params[:group_id])
    @competition = Competition.find(params[:competition_id])
    set_current_round
    @matches     = @round.matches
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

    def set_current_round
      @round = if params[:round]
                 @competition.rounds.find(params[:round])
               else
                 @competition.rounds.started.last ||
                 @competition.rounds.scheduled.first ||

                 @competition.rounds.first
               end
    end


end
