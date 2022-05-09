class CreateTreatmentPlanEntityConnections < ActiveRecord::Migration
  def change
    create_table :treatment_plan_entity_connections do |t|
      t.integer :treatment_plan_id
      t.integer :entity_id
      t.string :entity_type

      t.timestamps null: false
    end
  end
end
