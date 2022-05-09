class AddTimeColumnToSurveyConfigurations < ActiveRecord::Migration
  def change
    add_column :survey_configurations, :schedule_time, :time
  end
end
