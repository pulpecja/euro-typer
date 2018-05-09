class Admin::GroupsController < AdminController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @groups = Group.all
  end

  def show
  end

  def new
    @group = Group.new
    @users = User.existing
  end

  def edit
    @users = User.existing
  end

  def create
    @group = Group.new(group_params)
    add_users
    add_competitions
    if @group.save
      flash[:notice] = "Grupa stworzona"
      redirect_to(admin_groups_path)
    else
      flash[:error]  = "Nie udało się utworzyć grupy"
      render action: 'new'
    end
  end

  def update
    add_users
    add_competitions
    if @group.update(group_params)
      flash[:notice] = "Grupa zapisana"
      redirect_to(admin_groups_path)
    else
      flash[:error]  = "Nie udało się wyedytować grupy."
      render action: 'edit'
    end
  end

  def destroy
    @group.destroy
    flash[:notice] = 'Grupa usunięta!'
    redirect_to admin_groups_path
  end

  private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :token, :owner_id, user_ids: [], competition_ids: [])
    end

    def add_users
      @group.users = []
      params[:group][:user_ids].reject(&:empty?).each do |user_id|
        @group.users << User.find(user_id) #unless @group.users.include?(user)
      end
      @group.users << User.find(params[:group][:owner_id]) if params[:group][:owner_id].present?
    end

    def add_competitions
      @group.competitions = []
      params[:group][:competition_ids].reject(&:empty?).each do |competition_id|
        @group.competitions << Competition.find(competition_id) #unless @group.users.include?(user)
      end
    end
end
