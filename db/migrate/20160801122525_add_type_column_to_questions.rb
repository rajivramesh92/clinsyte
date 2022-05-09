class AddTypeColumnToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :type, :string
    remove_column :questions, :category
    remove_column :questions, :info
  end
end
