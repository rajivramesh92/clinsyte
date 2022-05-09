class DropAnswerOptionConnections < ActiveRecord::Migration
  def change
    drop_table :answer_option_connections
  end
end
