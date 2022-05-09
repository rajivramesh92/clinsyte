class CreatePhenotypes < ActiveRecord::Migration
  def change
    create_table :phenotypes do |t|
      t.string :name
      t.integer :variation_id

      t.timestamps null: false
    end
  end
end
