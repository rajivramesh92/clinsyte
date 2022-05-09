class CreateGenetics < ActiveRecord::Migration
  def change
    create_table :genetics do |t|
      t.string :name
      t.integer :patient_id

      t.timestamps null: false
    end
  end
end
