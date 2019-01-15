class Admin::CompetitionsController < AdminController
  before_action :set_competition, only: [:show, :update, :destroy]
  load_and_authorize_resource

  def index
    @competitions = Competition.all
    json_response(CompetitionSerializer, @competitions)
  end

  def show
    json_response(CompetitionSerializer, @competition)
  end

  def create
    @competition = Competition.create!(competition_params)
    json_response(CompetitionSerializer, @competition)
  end

  def update
    @competition.update!(competition_params)
    json_response(CompetitionSerializer, @competition)
  end

  def destroy
    @competition.destroy
    head :no_content
  end

  private
  def set_competition
    @competition = Competition.find(params[:id])
  end

  def competition_params
    params.require(:data).permit(
      attributes: [
        :name,
        :year,
        :place,
        :start_date,
        :end_date,
        :winner_id
      ]
    )
  end
end
