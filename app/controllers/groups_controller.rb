class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :update, :destroy]
  load_and_authorize_resource except: [:join]
  skip_authorization_check only: [:join]

  def index
    @groups = Group.all
    json_response(GroupSerializer, @groups)
  end

  def show
    json_response(GroupSerializer, @group)
  end

  def create
    @group = Group.create!(group_params)
    json_response(GroupSerializer, @group)
  end

  def update
    @group.update!(group_params)
    json_response(GroupSerializer, @group)
  end

  def destroy
    @group.destroy
    head :no_content
  end

  def join
    @group = Group.find_by(id: params[:group_id], token: params[:token])

    if @group
      @group.users << current_user
      json_response(GroupSerializer, @group)
    else
      render json: { message: 'Group not found' }, status: :not_found
    end
  end

  private
  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:data).permit(
      attributes: [
        :name,
        :token,
        :owner_id,
        user_ids: [],
        competition_ids: []
      ]
    )
  end

  # Temp fix, need to be removed bc there is rescue in ApplicationController,
  # but seems not to be working
  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message }, status: 403
  end

  # Not sure if needed 
  # def add_competitions
  #   group = GroupService.new(params[:group], @group)
  #   group.add_competitions
  # end
end
