class TypesController < ApplicationController
  before_action :set_type, only: [:show, :edit, :update, :destroy]
  respond_to :json

  # GET /types
  # GET /types.json
  def index
    @types = Type.all.includes({ match: [:first_team, :second_team] })
    @matches = Match.all
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
    #TODO add round number to link params
    @matches = Match.all
    @matches.each do |match|
      Type.find_or_create_by(user: current_user, match: match)
    end
    redirect_to types_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type
      @type = Type.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_params
      params.require(:type).permit(:user_id, :match_id, :first_score, :second_score)
    end
end
