class CreaturesController < ApplicationController
  before_action :user_authorized?, only: %i[edit update destroy]

  def index
    get_creature_index
  end

  def new
    @creature = Creature.new
  end

  def create
    @creature = Creature.create(creature_params)

    if @creature.persisted?
      flash[:notice] = "#{@creature.name} successfully created!"
      get_creature_index
      render :index
    else
      flash[:alert] = "Creature could not be created!"
      render :new
    end
  end

  def edit; end

  def update
    if @creature.update(creature_params)
      flash[:notice] = "#{@creature.name} successfully updated!"
      get_creature_index
      render :index
    else
      flash[:alert] = "#{@creature.name} could not be update!"
      render :edit
    end
  end

  def destroy
    @creature.destroy
    flash[:notice] = "#{@creature.name} successfully deleted."
    redirect_to creatures_path
  end

  private

  def creature_params
    params.require(:creature)
          .permit(:name, :variety, :armor_class, :initiative_bonus, :advantage,
                  :initiative_value)
          .merge(user_id: current_user.id)
  end

  def get_creature_index
    @players = current_user.players
    @npcs = current_user.npcs
    @events = current_user.events
  end

  def user_authorized?
    @creature = Creature.find(params[:id])
    if current_user.id != @creature.user_id
      flash[:alert] = 'You are not permitted to perfom this action.'
      redirect_to '/'
    end
  end
end
