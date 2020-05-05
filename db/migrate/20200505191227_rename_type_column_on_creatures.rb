class RenameTypeColumnOnCreatures < ActiveRecord::Migration[6.0]
  def change
    rename_column :creatures, :type, :variety
    change_column_null :creatures, :armor_class, true
  end
end
