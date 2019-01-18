class TypesController < ApplicationController
  before_action :set_type, only: [:show, :update, :destroy]
  load_and_authorize_resource

  def index
    @types = Type.all.by_user(@current_user)
    json_response(TypeSerializer, @types)
  end

  def show
    json_response(TypeSerializer, @type)
  end

  def create
    @type = Type.create!(type_params)
    json_response(TypeSerializer, @type)
  end

  def update
    @type.update!(type_params)
    json_response(TypeSerializer, @type)
  end

  def destroy
    @type.destroy
    head :no_content
  end

  private
  # Method to deal with score as a string, may be useful someday,
  # if we change approach to scoring
  # def check_scores_type
  #   attr_names = ['first_score', 'second_score']
  #
  #   params[:data][:attributes].each do |attr|
  #     if attr_names.include?(attr[0])
  #       begin
  #         Integer(attr[1])
  #       rescue ArgumentError
  #         params[:data][:attributes][attr[0].to_s] = nil
  #       end
  #     else
  #       next
  #     end
  #   end
  # end

  def set_type
    @type = Type.find(params[:id])
  end

  def set_round
    @round = Round.find(params[:round_id])
  end

  def set_matches
    @matches = Match.includes(:first_team, :second_team).by_round(@round)
  end

  def type_params
    params.require(:data).permit(
      attributes: [
        :user_id,
        :match_id,
        :first_score,
        :second_score,
        :bet
      ]
    )
  end

  # Temp fix, need to be removed bc there is rescue in ApplicationController,
  # but seems not to be working
  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message }, status: 403
  end
end
