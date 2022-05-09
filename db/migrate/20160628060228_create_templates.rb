class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.integer :strain_id
      t.integer :creator_id
      t.string :name

      t.timestamps null: false
    end
  end
end
