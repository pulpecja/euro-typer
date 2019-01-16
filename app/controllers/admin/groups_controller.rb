class Admin::GroupsController < AdminController
  before_action :set_group, only: [:show, :update, :destroy]
  load_and_authorize_resource

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
end
