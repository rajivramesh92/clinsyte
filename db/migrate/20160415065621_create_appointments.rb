class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :physician_id
      t.integer :patient_id
      t.date :date
      t.float :from_time
      t.float :to_time
      t.integer :status, :default => 0

      t.timestamps null: false
    end
  end
end
