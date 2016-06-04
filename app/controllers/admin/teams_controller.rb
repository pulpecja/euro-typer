class Admin::TeamsController < AdminController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # skip_before_filter :require_admin!, only: [:index]

  def index
    @teams = Team.all.order(:name)
  end

  def show
  end

  def new
    @team = Team.new
  end

  def edit
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      flash[:notice] = "Drużyna utworzona"
      redirect_to(admin_teams_path)
    else
      flash[:error]  = "Nie udało się utworzyć drużyny"
      render action: 'new'
    end

  end

  def update
    if @team.update(team_params)
      flash[:notice] = "Drużyna zapisana"
      redirect_to(admin_teams_path)
    else
      flash[:error]  = "Nie udało się wyedytować drużyny."
      render action: 'edit'
    end
  end

  def destroy
    @team.destroy
    flash[:notice] = 'Drużyna usunięta!'
    redirect_to admin_teams_path
  end

  private
    def set_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(:name, :abbreviation, :flag, :photo)
    end

end