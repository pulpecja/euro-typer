class CompetitionsController < ApplicationController
  before_action :set_competition, only: [:show]
  load_and_authorize_resource

  def index
    @group = Group.find(params['group_id'])
    @competitions = @group.competitions
  end

  def show
    @groups = current_user.groups.includes(:users, :competitions)
    set_current_round
    @matches = @round.matches
  end

  private
    def set_competition
      @competition = Competition.find(params[:id])
    end

    def competition_params
      params.require(:competition).permit(:name, :year, :place)
    end

    def set_current_round
      @round = if params[:round]
                 Round.find(params[:round])
               else
                 Round.scheduled.where(competition: @competition).first ||
                 Round.finished.where(competition: @competition).last ||
                 Round.first
               end
    end
end
