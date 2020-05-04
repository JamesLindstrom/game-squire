class GameSpacesController < ApplicationController
  def show
    @game_space = current_user.game_spaces.find(params[:id])
  end

  def new
    @game_space = GameSpace.new
  end
end
