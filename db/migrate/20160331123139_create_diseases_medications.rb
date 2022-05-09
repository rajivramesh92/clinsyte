class CreateDiseasesMedications < ActiveRecord::Migration
  def change
    create_table :diseases_medications do |t|
      t.references :disease, index: true, foreign_key: true
      t.references :medication, index: true, foreign_key: true
    end
  end
end
