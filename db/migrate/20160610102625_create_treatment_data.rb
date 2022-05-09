class CreateTreatmentData < ActiveRecord::Migration
  def change
    create_table :treatment_data do |t|
      t.integer :treatment_plan_id
      t.integer :intake_count
      t.time :last_intake
      t.time :last_reminded

      t.timestamps null: false
    end
  end
end
