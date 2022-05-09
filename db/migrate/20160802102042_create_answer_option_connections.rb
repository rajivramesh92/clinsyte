class CreateAnswerOptionConnections < ActiveRecord::Migration
  def change
    create_table :answer_option_connections do |t|
      t.integer :answer_id
      t.integer :option_id

      t.timestamps null: false
    end
  end
end
