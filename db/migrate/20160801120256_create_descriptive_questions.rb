class CreateDescriptiveQuestions < ActiveRecord::Migration
  def change
    create_table :descriptive_questions do |t|

      t.timestamps null: false
    end
  end
end
