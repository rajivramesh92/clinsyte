class AddTitleColumnToTreatMentPlan < ActiveRecord::Migration
  def change
    add_column :treatment_plans, :title, :string
  end
end
