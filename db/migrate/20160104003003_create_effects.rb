class CreateEffects < ActiveRecord::Migration
  def change
    create_table :effects do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
