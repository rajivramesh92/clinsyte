class RenameTreatmentPlanIdInTreatplanData < ActiveRecord::Migration
  def change
    rename_column :treatment_data, :treatment_plan_id, :treatment_plan_therapy_id
  end
end
