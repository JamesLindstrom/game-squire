class AddCurrentEncounterIdToGameSpace < ActiveRecord::Migration[6.0]
  def change
    add_column :game_spaces, :current_encounter_id, :integer
  end
end
