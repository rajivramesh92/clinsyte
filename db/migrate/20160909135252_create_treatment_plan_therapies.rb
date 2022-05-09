class CreateTreatmentPlanTherapies < ActiveRecord::Migration
  def change
    create_table :treatment_plan_therapies do |t|
      t.integer :treatment_plan_id
      t.integer :strain_id
      t.float :dosage_quantity
      t.string :dosage_unit
      t.string :message
      t.integer :intake_timing

      t.timestamps null: false
    end
  end
end
