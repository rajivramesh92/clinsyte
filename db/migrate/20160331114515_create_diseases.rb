class CreateDiseases < ActiveRecord::Migration
  def change
    create_table :diseases do |t|
      t.references :condition, :index => true, :foreign_key => true
      t.integer :patient_id
      t.date :diagnosis_date

      t.timestamps null: false
    end
  end
end
