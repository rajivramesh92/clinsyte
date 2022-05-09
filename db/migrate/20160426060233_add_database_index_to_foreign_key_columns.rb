class AddDatabaseIndexToForeignKeyColumns < ActiveRecord::Migration
  def change
    add_index :careteams, :patient_id
    add_index :categories_strains, :strain_id
    add_index :categories_strains, :category_id
    add_index :conditions_strains, :strain_id
    add_index :conditions_strains, :condition_id
    add_index :diseases, :patient_id
    add_index :notifications, [ :sender_id, :sender_type ]
    add_index :notifications, [ :recipient_id, :recipient_type ]
    add_index :requests, :patient_id
    add_index :requests, :physician_id
    add_index :appointment_preferences, :physician_id
    add_index :appointments, :physician_id
    add_index :appointments, :patient_id
    add_index :slots, :physician_id
  end
end
