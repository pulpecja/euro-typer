class Admin::MatchesController < AdminController
  before_action :set_match, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # skip_before_filter :require_admin!, only: [:index]

  def index
    @competitions = Competition.all.order('id desc')
  end

  def show
  end

  def new
    @match = Match.new
  end

  def edit
  end

  def create
    @match = Match.new(match_params)

    if @match.save
      flash[:notice] = "Mecz stworzony"
      redirect_to(admin_matches_path)
    else
      flash[:error]  = "Nie udało się utworzyć meczu"
      render action: 'new'
    end

  end

  def update
    if @match.update(match_params)
      flash[:notice] = "Mecz zapisany"
      redirect_to(admin_matches_path)
    else
      flash[:error]  = "Nie udało się wyedytować meczu."
      render action: 'edit'
    end
  end

  def destroy
    @match.destroy
    flash[:notice] = 'Mecz usunięty!'
    redirect_to admin_matches_path
  end

  private
    def set_match
      @match = Match.find(params[:id])
    end

    def match_params
      params.require(:match).permit(:first_team_id, :second_team_id, :played, :first_score, :second_score, :round_id)
    end

end