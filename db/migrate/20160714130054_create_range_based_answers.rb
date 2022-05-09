class CreateRangeBasedAnswers < ActiveRecord::Migration
  def change
    create_table :range_based_answers do |t|

      t.timestamps null: false
    end
  end
end
