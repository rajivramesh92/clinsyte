class AddDestroyedColumnInQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :status, :integer, :default => 0
  end
end
