class AddIndexToMissingColumns < ActiveRecord::Migration
  def change
    add_index :answers, :creator_id
    add_index :answers, :request_id
    add_index :answers, :choice_id
    add_index :choices, :question_id
    add_index :disease_therapy_connections, :strain_id
    add_index :event_dependent_surveys, :survey_id
    add_index :event_dependent_surveys, :physician_id
    add_index :field_values, [ :entity_id, :entity_type ]
    add_index :genetics, :patient_id
    add_index :phenotypes, :variation_id
    add_index :survey_configurations, :survey_id
    add_index :survey_configurations, :sender_id
    add_index :survey_receipients, [ :survey_id, :survey_type ]
    add_index :surveys, :creator_id
    add_index :template_data, :template_id
    add_index :treatment_data, :treatment_plan_id
    add_index :templates, :strain_id
    add_index :templates, :creator_id
    add_index :treatment_plans, :strain_id
    add_index :treatment_plans, :patient_id
    add_index :user_survey_forms, :sender_id
    add_index :user_survey_forms, :receiver_id
    add_index :users, [ :invited_by_id, :invited_by_type ]
    add_index :variations, :genetic_id
  end
end
