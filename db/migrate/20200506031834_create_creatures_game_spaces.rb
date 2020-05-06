class CreateCreaturesGameSpaces < ActiveRecord::Migration[6.0]
  def change
    create_join_table :creatures, :game_spaces
  end
end
