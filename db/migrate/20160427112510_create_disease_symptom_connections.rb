class CreateDiseaseSymptomConnections < ActiveRecord::Migration
  def change
    create_table :disease_symptom_connections do |t|
      t.references :disease, index: true, foreign_key: true
      t.references :symptom, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
