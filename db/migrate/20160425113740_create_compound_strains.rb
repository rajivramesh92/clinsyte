class CreateCompoundStrains < ActiveRecord::Migration
  def change
    create_table :compound_strains do |t|
      t.references :compound, index: true, foreign_key: true
      t.references :strain, index: true, foreign_key: true
      t.decimal :high
      t.decimal :low
      t.decimal :average

      t.timestamps null: false
    end
  end
end
