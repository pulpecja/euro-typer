class CompetitionsController < ApplicationController
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
  def default_competition
    Setting.find_by(name: 'default_competition').value
  end

  def set_competition
    @competition = Competition.find(params[:id] || default_competition)
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
