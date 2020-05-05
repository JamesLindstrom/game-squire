class GameSpacesController < ApplicationController
  before_action :user_authorized?, only: %i[show edit update destroy]

  def show; end

  def new
    @game_space = GameSpace.new
  end

  def create
    @game_space = GameSpace.create(game_space_params)

    if @game_space.persisted?
      flash[:notice] = "#{@game_space.name} successfully created!"
      render :show
    else
      flash[:alert] = "Game Space could not be created!"
      render :new
    end
  end

  def edit; end

  def update
    if @game_space.update(game_space_params)
      flash[:notice] = "#{@game_space.name} successfully updated!"
      render :show
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

  private

  def game_space_params
    params.require(:game_space).permit(:name).merge(user_id: current_user.id)
  end

  def user_authorized?
    @game_space = GameSpace.find(params[:id])
    if current_user.id != @game_space.user_id
      flash[:alert] = 'You are not permitted to perfom this action.'
      redirect_to '/'
    end
  end
end
