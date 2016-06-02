class TypesController < ApplicationController
  before_action :set_type, only: [:show, :edit, :update, :destroy]
  before_action :set_round, only: [:index, :prepare]

  load_and_authorize_resource except: [:prepare]
  skip_authorization_check only: [:prepare]
  respond_to :json

  # GET /types
  # GET /types.json
  def index
    @types = Type.by_user(current_user)
    @matches = Match.by_round(@round)
  end

  # GET /types/1
  # GET /types/1.json
  def show
  end

  # GET /types/new
  def new
    @type = Type.new
  end

  # GET /types/1/edit
  def edit
  end

  # POST /types
  # POST /types.json
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

  # PATCH/PUT /types/1
  # PATCH/PUT /types/1.json
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

  # DELETE /types/1
  # DELETE /types/1.json
  def destroy
    @type.destroy
    respond_to do |format|
      format.html { redirect_to types_url, notice: 'Type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def prepare
    @matches = Match.by_round(@round)
    @matches.each do |match|
      Type.find_or_create_by(user: current_user, match: match)
    end
    redirect_to round_types_path(@round.id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type
      @type = Type.find(params[:id])
    end

    def set_round
      @round = Round.find(params[:round_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_params
      params.require(:type).permit(:user_id, :match_id, :first_score, :second_score)
    end
end
