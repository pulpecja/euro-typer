class Admin::RoundsController < AdminController
  before_action :set_round, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # skip_before_filter :require_admin!, only: [:index]

  def index
    @rounds = Round.includes(:matches).all
  end

  def show
  end

  def new
    @round = Round.new
  end

  def edit
  end

  def create
    @round = Round.new(round_params)

    if @round.save
      flash[:notice] = "Kolejka utworzona"
      redirect_to(admin_rounds_path)
    else
      flash[:error]  = "Nie udało się utworzyć kolejki"
      render action: 'new'
    end

  end

  def update
    if @round.update(round_params)
      flash[:notice] = "Kolejka zapisana"
      redirect_to(admin_rounds_path)
    else
      flash[:error]  = "Nie udało się wyedytować kolejki."
      render action: 'edit'
    end
  end

  def destroy
    @round.destroy
    flash[:notice] = 'Kolejka usunięta!'
    redirect_to admin_rounds_path
  end

  private
    def set_round
      @round = Round.find(params[:id])
    end

    def round_params
      params.require(:round).permit(:name)
    end

end