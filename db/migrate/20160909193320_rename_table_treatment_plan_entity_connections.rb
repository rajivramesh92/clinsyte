class RenameTableTreatmentPlanEntityConnections < ActiveRecord::Migration
  def change
    rename_table :treatment_plan_entity_connections, :therapy_entity_connections
  end
end
