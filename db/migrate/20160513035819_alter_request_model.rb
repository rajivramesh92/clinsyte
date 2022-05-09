class AlterRequestModel < ActiveRecord::Migration
  def change
    rename_column :requests, :patient_id, :sender_id
    rename_column :requests, :physician_id, :recipient_id
  end
end
