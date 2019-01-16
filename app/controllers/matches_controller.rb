class MatchesController < ApplicationController
  before_action :set_competition, only: [:show]
  load_and_authorize_resource

  def index
    @matches = Match.all
    json_response(MatchSerializer, @matches)
  end

  def show
    json_response(MatchSerializer, @match)
  end

  private
  def set_competition
    @match = Match.find(params[:id])
  end

  # Temp fix, need to be removed bc there is rescue in ApplicationController,
  # but seems not to be working
  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message }, status: 403
  end
end
