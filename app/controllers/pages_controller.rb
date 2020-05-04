class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @game_spaces = current_user.game_spaces if current_user
  end
end
