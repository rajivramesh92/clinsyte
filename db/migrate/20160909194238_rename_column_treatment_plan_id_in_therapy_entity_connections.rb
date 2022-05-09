class RenameColumnTreatmentPlanIdInTherapyEntityConnections < ActiveRecord::Migration
  def change
    rename_column :therapy_entity_connections, :treatment_plan_id, :treatment_plan_therapy_id
  end
end
