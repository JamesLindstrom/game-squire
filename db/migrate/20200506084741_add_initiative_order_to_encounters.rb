class AddInitiativeOrderToEncounters < ActiveRecord::Migration[6.0]
  def change
    add_column :encounters, :initiative_order, :json
  end
end
