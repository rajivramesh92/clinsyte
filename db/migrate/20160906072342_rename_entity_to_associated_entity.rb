class RenameEntityToAssociatedEntity < ActiveRecord::Migration
  def change
    rename_column :treatment_plan_entity_connections, :entity_id, :associated_entity_id
    rename_column :treatment_plan_entity_connections, :entity_type, :associated_entity_type
  end
end
