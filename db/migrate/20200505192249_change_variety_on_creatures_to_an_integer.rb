class ChangeVarietyOnCreaturesToAnInteger < ActiveRecord::Migration[6.0]
  def up
    change_column :creatures, :variety, :integer
  end

  def down
    change_column :creatures, :variety, :string
  end
end
