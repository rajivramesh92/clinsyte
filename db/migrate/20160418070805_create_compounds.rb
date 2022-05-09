class CreateCompounds < ActiveRecord::Migration
  def change
    create_table :compounds do |t|
      t.string :name
      t.decimal :high
      t.decimal :low
      t.decimal :average
      t.references :tag, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
