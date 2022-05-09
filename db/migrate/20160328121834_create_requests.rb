class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :patient_id
      t.integer :physician_id
      t.integer :status

      t.timestamps null: false
    end
  end
end
