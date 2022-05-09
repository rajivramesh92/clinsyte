class CreateSelectedOptions < ActiveRecord::Migration
  def change
    create_table :selected_options do |t|
      t.integer :answer_id
      t.string :option

      t.timestamps null: false
    end
  end
end
