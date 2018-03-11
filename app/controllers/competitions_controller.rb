class CompetitionsController < ApplicationController
  before_action :set_competition, only: [:show]
  load_and_authorize_resource

  def index
    @competitions = Competition.all
  end

  def show
  end

  private
    def set_competition
      @competition = Competition.find(params[:id])
    end

    def competition_params
      params.require(:competition).permit(:name, :year, :place)
    end
end
