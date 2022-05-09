class CreateVariations < ActiveRecord::Migration
  def change
    create_table :variations do |t|
      t.string :name
      t.string :chromosome
      t.integer :position
      t.string :genotype
      t.string :maf
      t.integer :genetic_id

      t.timestamps null: false
    end
  end
end
