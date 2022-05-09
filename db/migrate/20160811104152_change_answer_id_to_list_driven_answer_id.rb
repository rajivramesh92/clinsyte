class ChangeAnswerIdToListDrivenAnswerId < ActiveRecord::Migration
  def change
    rename_column :selected_options, :answer_id, :list_driven_answer_id
  end
end
