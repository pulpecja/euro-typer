class CompetitionsController < ApplicationController
  before_action :set_competition, only: [:show]
  load_and_authorize_resource

  def index
    @competitions = Competition.all.order(:name)
    json_response(CompetitionSerializer, @competitions)
  end

  def show
    json_response(CompetitionSerializer, @competition)
  end

  private
  def set_competition
    @competition = Competition.find(params[:id])
  end

  # Temp fix, need to be removed bc there is rescue in ApplicationController,
  # but seems not to be working
  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message }, status: 403
  end
end
