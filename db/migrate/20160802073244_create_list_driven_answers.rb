class CreateListDrivenAnswers < ActiveRecord::Migration
  def change
    create_table :list_driven_answers do |t|

      t.timestamps null: false
    end
  end
end
