class CreateEncounters < ActiveRecord::Migration[6.0]
  def change
    create_table :encounters do |t|
      t.string :name, null: false
      t.json   :history
    end

    add_reference :encounters, :game_space, index: true
    create_join_table :creatures, :encounters do |t|
      t.integer :initiative
    end
  end
end
