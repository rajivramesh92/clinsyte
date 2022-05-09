class CreateDiseaseTherapyConnections < ActiveRecord::Migration
  def change
    create_table :disease_therapy_connections do |t|
      t.references :disease, index: true, foreign_key: true
      t.integer :therapy_id

      t.timestamps null: false
    end
  end
end