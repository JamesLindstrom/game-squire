class GameSpacesController < ApplicationController
  skip_before_action :authenticate_user!, only: :guest_view
  before_action :user_authorized?, only: %i[show edit update destroy live_toggle]

  def show
    @players = @game_space.players
    @encounters = @game_space.encounters
    @encounter = @game_space.current_encounter
  end

  def new
    @game_space = GameSpace.new
  end

  def create
    @game_space = GameSpace.create(game_space_params)

    if @game_space.persisted?
      flash[:notice] = "#{@game_space.name} successfully created!"
      redirect_to game_space_path(@game_space)
    else
      flash[:alert] = "Game Space could not be created!"
      render :new
    end
  end

  def edit; end

  def update
    if @game_space.update(game_space_params)
      flash[:notice] = "#{@game_space.name} successfully updated!"
      redirect_to game_space_path(@game_space)
    else
      flash[:alert] = "#{@game_space.name} could not be update!"
      render :edit
    end
  end

  def destroy
    @game_space.destroy
    flash[:notice] = "#{@game_space.name} successfully deleted."
    redirect_to '/'
  end

  def live_toggle
    if @game_space.public
      @game_space.update(public: false)
    else
      @game_space.update(public: true)
    end

    Rails.cache.delete("guest_view_#{@game_space.link}")
  end

  def guest_view
    @game_space = Rails.cache.fetch("guest_view_#{params[:pass]}", expires_in: 1.minute) do
      GameSpace.includes(current_encounter: :creatures).find(params[:game_space_id])
    end

    if @game_space.link != params[:pass]
      flash[:alert] = 'This secret link is incorrect.'
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { head :unauthorized }
      end
    end

    unless @game_space.public
      flash[:alert] = 'This encounter is not currently live.'
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { head :unauthorized }
      end
    end
  end

  private

  def game_space_params
    temp_params = params.require(:game_space)
                        .permit(:name, player_ids: [])
                        .merge(user_id: current_user.id)

    # Make sure player_ids match those belonging to the current_user
    valid_ids = current_user.players.pluck(:id)
    temp_params[:player_ids] = temp_params[:player_ids].select do |player_id|
      valid_ids.include?(player_id.to_i)
    end

    temp_params
  end

  def user_authorized?
    @game_space = GameSpace.find(params[:id])
    if current_user.id != @game_space.user_id
      flash[:alert] = 'You are not permitted to perfom this action.'
      redirect_to '/'
    end
  end
end
