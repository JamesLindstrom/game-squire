class ChangeVarietyOnCreaturesToAnInteger < ActiveRecord::Migration[6.0]
  def up
    change_column :creatures, :variety, 'integer USING CAST(column_name AS integer)'
  end

  def down
    change_column :creatures, :variety, :string
  end
end
