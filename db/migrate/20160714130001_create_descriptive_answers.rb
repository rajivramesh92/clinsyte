class CreateDescriptiveAnswers < ActiveRecord::Migration
  def change
    create_table :descriptive_answers do |t|

      t.timestamps null: false
    end
  end
end
