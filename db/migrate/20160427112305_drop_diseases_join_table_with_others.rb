class DropDiseasesJoinTableWithOthers < ActiveRecord::Migration
  def change
    drop_table :diseases_symptoms
    drop_table :diseases_medications
  end
end
