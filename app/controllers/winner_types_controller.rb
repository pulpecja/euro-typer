class WinnerTypesController < ApplicationController
  before_action :set_winner_type, only: [:edit, :update]
  before_action :set_competition, only: [:new, :create, :edit, :update]

  load_and_authorize_resource except: [:prepare]
  skip_authorization_check only: [:prepare]

  def new
    @winner_type = WinnerType.new
  end

  def edit
  end

  def create
    @winner_type = WinnerType.new(winner_type_params)
    @winner_type.user = current_user

    respond_to do |format|
      if @winner_type.save
        format.html { redirect_to @competition, notice: 'Typ stworzony.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @winner_type.update(winner_type_params)
    respond_to do |format|
      if @winner_type.save
        format.html { redirect_to @competition, notice: 'Typ zmieniony.' }
      else
        format.html { render :new }
      end
    end
  end

  private
    def set_winner_type
      @winner_type = WinnerType.find(params[:id])
    end

    def winner_type_params
      params.require(:winner_type).permit(:team_id, :competition_id)
    end

    def set_competition
      @competition = Competition.find(params[:competition] || params.dig(:winner_type, :competition_id))
    end

end