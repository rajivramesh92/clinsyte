class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :description
      t.references :question, index: true, foreign_key: true
      t.integer :creator_id

      t.timestamps null: false
    end
  end
end
