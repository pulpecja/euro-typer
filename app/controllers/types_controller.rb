class TypesController < ApplicationController
  before_action :set_type, only: [:show, :edit, :update, :destroy]
  before_action :set_round, only: [:index, :prepare]
  before_action :set_matches, only: [:index]
  before_action :prepare, only: [:index]

  load_and_authorize_resource except: [:prepare]
  skip_authorization_check only: [:prepare]
  respond_to :json

  def index
    @types = Type.by_user(current_user)
  end

  def show
  end

  def new
    @type = Type.new
  end

  def edit
  end

  def create
    @type = Type.new(type_params)

    respond_to do |format|
      if @type.save
        format.html { redirect_to @type, notice: 'Type was successfully created.' }
        format.json { render :show, status: :created, location: @type }
      else
        format.html { render :new }
        format.json { render json: @type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @type.update(type_params)
        format.json { head :no_content }
        format.html { redirect_to @type, notice: 'Type was successfully updated.' }
      else
        format.json { render json: @type.errors, status: :unprocessable_entity }
        format.html { render :edit }
      end
    end
  end

  def destroy
    @type.destroy
    respond_to do |format|
      format.html { redirect_to types_url, notice: 'Type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def prepare
    @matches.each do |match|
      Type.find_or_create_by(user: current_user, match: match)
    end
  end

  private
    def set_type
      @type = Type.find(params[:id])
    end

    def set_round
      @round = Round.find(params[:round_id])
    end

    def set_matches
      @matches = Match.by_round(@round)
    end

    def type_params
      params.require(:type).permit(:user_id, :match_id, :first_score, :second_score, :bet)
    end
end
