class CreateDiseasesSymptoms < ActiveRecord::Migration
  def change
    create_table :diseases_symptoms do |t|
      t.references :disease, index: true, foreign_key: true
      t.references :symptom, index: true, foreign_key: true
    end
  end
end
