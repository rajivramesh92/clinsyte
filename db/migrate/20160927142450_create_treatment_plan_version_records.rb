class CreateTreatmentPlanVersionRecords < ActiveRecord::Migration
  def change
    create_table :treatment_plan_version_records do |t|
      t.integer :user_survey_form_id
      t.integer :treatment_plan_id
      t.integer :treatment_plan_version

      t.timestamps null: false
    end
  end
end
