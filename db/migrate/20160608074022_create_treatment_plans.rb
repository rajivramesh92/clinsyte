class CreateTreatmentPlans < ActiveRecord::Migration
  def change
    create_table :treatment_plans do |t|
      t.integer :therapy_id
      t.float :dosage_quantity
      t.string :dosage_unit
      t.integer :patient_id
      t.string :message

      t.timestamps null: false
    end
  end
end
