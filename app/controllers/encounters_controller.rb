class EncountersController < ApplicationController
  before_action :user_authorized?, except: %i[new create]
  before_action :not_current?, only: %i[edit update destroy run]
  after_action :expire_cache, only: %i[run next_turn end_encounter update destroy]

  def show; end

  def new
    @encounter = Encounter.new(game_space_id: params[:game_space_id], creature_ids: default_player_ids)
  end

  def create
    @encounter = Encounter.create(encounter_params)

    if @encounter.persisted?
      index_variables
    else
      render :new
    end
  end

  def edit; end

  def update
    if @encounter.update(encounter_params)
      index_variables
    else
      render :edit
    end
  end

  def destroy
    @encounter.destroy
    index_variables
  end

  def run
    @encounter.roll_initiative
    @encounter.next_turn
    @encounter.game_space.update(current_encounter_id: @encounter.id)
  end

  def next_turn
    @encounter.next_turn
  end

  def end_current
    @encounter.game_space.update(current_encounter: nil)
  end

  def toggle_creature
    render 'no_toggle' unless @encounter.toggle_creature(params[:creature_id])
  end

  def add_creature_form
    @creatures = current_user.creatures.where.not(id: @encounter.creatures.pluck(:id))
  end

  def add_creature
    creature = current_user.creatures.find(params[:creature_id])
    @encounter.add_creature_to_initiative(creature)
  end

  private

  def default_player_ids
    GameSpace.find(params[:game_space_id]).players.pluck(:id)
  end

  def encounter_params
    temp_params = params.require(:encounter)
                        .permit(:name, :history, :game_space_id,
                                creature_ids: [])

    # Make sure game_space_id belongs to the current_user
    user_id = GameSpace.find_by_id(temp_params[:game_space_id])&.user_id
    redirect_to root_path unless user_id == current_user.id

    # Make sure creature_ids match those belonging to the current_user
    valid_ids = current_user.creatures.pluck(:id)
    temp_params[:creature_ids] = temp_params[:creature_ids].select do |creature_id|
      valid_ids.include?(creature_id.to_i)
    end

    temp_params
  end

  def expire_cache
    Rails.cache.delete("guest_view_#{@encounter.game_space.link}")
  end

  def index_variables
    @game_space = @encounter.game_space
    @encounters = @game_space.encounters
  end

  def user_authorized?
    @encounter = Encounter.includes(:game_space, :creatures).find(params[:id])
    if current_user.id != @encounter.game_space.user_id
      flash[:alert] = 'You are not permitted to perfom this action.'
      redirect_to '/'
    end
  end

  def not_current?
    if @encounter.game_space.current_encounter_id == @encounter.id
      render 'cannot_perform'
    end
  end
end
