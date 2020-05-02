class CreateCreatures < ActiveRecord::Migration[6.0]
  def change
    create_table :creatures do |t|
      t.string :name, null: false
      t.string :type, null: false

      # For Players and NPCs
      t.integer :armor_class,      null: false
      t.integer :initiative_bonus
      t.boolean :advantage

      # For Events
      t.integer :initiative_value
    end

    add_reference :creatures, :user, index: true
  end
end
