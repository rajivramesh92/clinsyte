class AddTreatmentPlanDependentColumnToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :treatment_plan_dependent, :boolean, :default => false
  end
end
