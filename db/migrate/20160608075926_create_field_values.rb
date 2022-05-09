class CreateFieldValues < ActiveRecord::Migration
  def change
    create_table :field_values do |t|
      t.string :name
      t.string :value

      t.timestamps null: false
    end
  end
end
