class CreateMedications < ActiveRecord::Migration
  def change
    create_table :medications do |t|
      t.text :name
      t.text :description

      t.timestamps null: false
    end
  end
end
