class CreateAppointmentPreferences < ActiveRecord::Migration
  def change
    create_table :appointment_preferences do |t|
      t.integer :physician_id
      t.boolean :auto_confirm, :default => false

      t.timestamps null: false
    end
  end
end
