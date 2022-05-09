class AddCreatorToTreatmentPlan < ActiveRecord::Migration
  def change
    add_column :treatment_plans, :creator_id, :integer
  end
end
