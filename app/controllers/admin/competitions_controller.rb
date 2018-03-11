class Admin::CompetitionsController < ApplicationController
  before_action :set_competition, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @competitions = Competition.all
  end

  def show
  end

  def new
    @competition = Competition.new
  end

  def edit
  end

  def create
    @competition = Competition.new(competition_params)

    if @competition.save
      flash[:notice] = "Turniej stworzony"
      redirect_to(admin_competitions_path)
    else
      flash[:error]  = "Nie udało się utworzyć turnieju"
      render action: 'new'
    end
  end

  def update
    if @competition.update(competition_params)
      flash[:notice] = "Turniej zapisany"
      redirect_to(admin_competitions_path)
    else
      flash[:error]  = "Nie udało się wyedytować turnieju."
      render action: 'edit'
    end
  end

  def destroy
    @competition.destroy
    flash[:notice] = 'Turniej usunięty!'
    redirect_to admin_competitions_path
  end

  private
    def set_competition
      @competition = Competition.find(params[:id])
    end

    def competition_params
      params.require(:competition).permit(:name, :year, :place)
    end
end
