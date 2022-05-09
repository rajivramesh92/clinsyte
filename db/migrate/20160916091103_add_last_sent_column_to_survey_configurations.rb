class AddLastSentColumnToSurveyConfigurations < ActiveRecord::Migration
  def change
    add_column :survey_configurations, :last_acknowledged, :datetime
  end
end
