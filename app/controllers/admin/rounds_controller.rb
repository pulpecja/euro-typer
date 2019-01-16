class Admin::RoundsController < AdminController
  before_action :set_round, only: [:show, :update, :destroy]
  load_and_authorize_resource

  def index
    @rounds = Round.all
    json_response(RoundSerializer, @rounds)
  end

  def show
    json_response(RoundSerializer, @round)
  end

  def create
    @round = Round.create!(round_params)
    json_response(RoundSerializer, @round)
  end

  def update
    @round.update!(round_params)
    json_response(RoundSerializer, @round)
  end

  def destroy
    @round.destroy
    head :no_content
  end

  private
  def set_round
    @round = Round.find(params[:id])
  end

  def round_params
    params.require(:data).permit(
      attributes: [
        :name,
        :stage,
        :started_at,
        :competition_id
      ]
    )
  end
end