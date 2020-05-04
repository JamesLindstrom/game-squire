class PagesController < ApplicationController
  def home
    @game_spaces = current_user.game_spaces if current_user
  end
end
