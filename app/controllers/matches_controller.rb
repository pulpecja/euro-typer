class MatchesController < ApplicationController
  before_action :set_match, only: [:show]
  load_and_authorize_resource

  def index
    @group = Group.find(params[:group_id])
    @competition = Competition.find(params[:competition_id])
    set_current_round
    @matches = Match.includes(:first_team, :second_team).where(round_id: @round.id)
    @users = @group.users.existing.sort{|a,b| a.points(@round) <=> b.points(@round)}.reverse
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
        Round.find(params[:round])
      else
        Round.where(competition: @competition)
             .where('started_at < ?', DateTime.now).last ||
        Round.where(competition: @competition).first ||
        Round.first
      end
    end


end
