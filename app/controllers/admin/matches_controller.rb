class Admin::MatchesController < AdminController
  before_action :set_match, only: [:show, :update, :destroy]
  load_and_authorize_resource

  def index
    @matchs = Match.all
    json_response(MatchSerializer, @matchs)
  end

  def show
    json_response(MatchSerializer, @match)
  end

  def create
    @match = Match.create!(match_params)
    json_response(MatchSerializer, @match)
  end

  def update
    @match.update!(match_params)
    json_response(MatchSerializer, @match)
  end

  def destroy
    @match.destroy
    head :no_content
  end

  private
    def set_match
      @match = Match.find(params[:id])
    end

    def match_params
      params.require(:data).permit(
        attributes: [
          :first_score,
          :first_team_id,
          :round_id,
          :second_score,
          :second_team_id,
          :played
        ]
      )
    end
end