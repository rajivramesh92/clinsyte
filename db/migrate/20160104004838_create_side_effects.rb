class CreateSideEffects < ActiveRecord::Migration
  def change
    create_table :side_effects do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
