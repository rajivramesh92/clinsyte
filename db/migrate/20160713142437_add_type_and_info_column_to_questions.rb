class AddTypeAndInfoColumnToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :category, :integer, :default => 0
    add_column :questions, :info, :string
  end
end
