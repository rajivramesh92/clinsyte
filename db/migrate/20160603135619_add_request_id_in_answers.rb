class AddRequestIdInAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :request_id, :integer
  end
end
