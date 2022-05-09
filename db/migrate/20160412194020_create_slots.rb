class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.integer :physician_id
      t.time :from_time
      t.time :to_time
      t.integer :day

      t.timestamps null: false
    end
  end
end
