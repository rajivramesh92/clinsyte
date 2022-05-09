class AddVersionColumnToTreatmentPlan < ActiveRecord::Migration
  def change
    add_column :treatment_plans, :current_version, :integer, :default => 0
  end
end
