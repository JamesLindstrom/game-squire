class CreateGameSpaces < ActiveRecord::Migration[6.0]
  def change
    create_table :game_spaces do |t|
      t.string  :name, null: false
      t.string  :link, null: false
      t.boolean :public, null: false, default: false
    end

    add_reference :game_spaces, :user, index: true
  end
end
