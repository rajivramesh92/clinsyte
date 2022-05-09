class AddColumnsForStiInQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :max_range, :integer
    add_column :questions, :min_range, :integer
    add_column :questions, :list_id, :integer
  end
end
