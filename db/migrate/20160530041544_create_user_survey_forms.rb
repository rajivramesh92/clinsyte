class CreateUserSurveyForms < ActiveRecord::Migration
  def change
    create_table :user_survey_forms do |t|
      t.references :survey, index: true, foreign_key: true
      t.string :state
      t.integer :sender_id
      t.integer :receiver_id
      t.datetime :sent_at
      t.datetime :started_at
      t.datetime :submitted_at

      t.timestamps null: false
    end
  end
end
