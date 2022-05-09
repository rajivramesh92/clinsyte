class AddTypeAndRemoveDescriptionColumnFromAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :type, :string
    remove_column :answers, :description
  end
end
