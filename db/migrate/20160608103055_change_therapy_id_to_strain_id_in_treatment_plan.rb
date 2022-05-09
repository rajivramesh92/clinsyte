class ChangeTherapyIdToStrainIdInTreatmentPlan < ActiveRecord::Migration
  def change
    rename_column :treatment_plans, :therapy_id, :strain_id
  end
end
