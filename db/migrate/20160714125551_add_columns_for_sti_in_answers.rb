class AddColumnsForStiInAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :description, :text
    add_column :answers, :choice_id, :integer
    add_column :answers, :value, :integer
  end
end
