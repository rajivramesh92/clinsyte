class CreateSurveyConfigurations < ActiveRecord::Migration
  def change
    create_table :survey_configurations do |t|
      t.integer :survey_id
      t.date :from_date
      t.integer :days
      t.integer :sender_id

      t.timestamps null: false
    end
  end
end
