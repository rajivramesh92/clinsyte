class RemoveColumnsFromTreatmentPlans < ActiveRecord::Migration
  def change
    remove_column :treatment_plans, :strain_id
    remove_column :treatment_plans, :dosage_quantity
    remove_column :treatment_plans, :dosage_unit
    remove_column :treatment_plans, :message
  end
end