class RoundsController < ApplicationController
  before_action :set_round, only: [:show]
  load_and_authorize_resource

  def index
    @rounds = Round.all
  end

  def show
    @matches = Match.by_round(@round)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_round
      @round = Round.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def round_params
      params.require(:round).permit(:name)
    end
end
