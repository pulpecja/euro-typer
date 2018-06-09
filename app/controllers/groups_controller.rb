class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: [:join]
  skip_authorization_check only: [:join]

  def index
    @groups = current_user.groups.includes(:owner)
  end

  def show
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new(group_params)

    add_competitions
    @group.owner_id = current_user.id
    @group.users << current_user

    if @group.save
      flash[:notice] = "Grupa stworzona"
      redirect_to @group
    else
      flash[:error]  = "Nie udało się utworzyć grupy"
      render action: 'new'
    end


  end

  def update
    add_competitions
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Grupa zaktualizwana.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Grupa pomyślnie usunięta.' }
      format.json { head :no_content }
    end
  end

  def join
    @group = Group.find_by(id: params[:group_id], token: params[:token])

    if @group
      @group.users << current_user
      flash[:notice] = "Pomyślnie dodano do grupy #{@group.name}!"
      redirect_to @group
    else
      flash[:notice] = "Link jest błędny, nie udało się dodać"
    end
  end

  private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :token, competition_ids: [])
    end

    def add_competitions
      group = GroupService.new(params[:group], @group)
      group.add_competitions
    end
end
