class CompetitionsController < ApplicationController
  DEFAULT_COMPETITION_ID = 2
  before_action :set_competition, only: [:show]
  load_and_authorize_resource

  def index
    @group = Group.find(params['group_id'])
    @competitions = @group.competitions
  end

  def show
    @groups = current_user.groups
                          .includes(:competitions)
                          .select{ |g| g.competitions.include? @competition }

    if @groups.empty?
      redirect_to groups_path
    else
      set_current_round
      @matches = @round.matches
    end
  end

  private
    def set_competition
      @competition = Competition.find(params[:id] || DEFAULT_COMPETITION_ID)
    end

    def competition_params
      params.require(:competition).permit(:name, :year, :place)
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
