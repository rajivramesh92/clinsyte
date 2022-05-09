class AddStatusToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :status, :integer, :default => 0
  end
end
