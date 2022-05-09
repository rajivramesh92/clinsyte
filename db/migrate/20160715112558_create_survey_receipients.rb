class CreateSurveyReceipients < ActiveRecord::Migration
  def change
    create_table :survey_receipients do |t|
      t.integer :survey_id
      t.string :survey_type
      t.integer :receiver_id

      t.timestamps null: false
    end
  end
end
