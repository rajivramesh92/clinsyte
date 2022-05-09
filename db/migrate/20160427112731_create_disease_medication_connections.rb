class CreateDiseaseMedicationConnections < ActiveRecord::Migration
  def change
    create_table :disease_medication_connections do |t|
      t.references :disease, index: true, foreign_key: true
      t.references :medication, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
