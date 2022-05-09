class CreateEventDependentSurveys < ActiveRecord::Migration
  def change
    create_table :event_dependent_surveys do |t|
      t.integer :survey_id
      t.integer :physician_id
      t.integer :time

      t.timestamps null: false
    end
  end
end
