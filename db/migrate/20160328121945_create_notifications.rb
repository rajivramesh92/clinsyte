class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :sender_id
      t.string :sender_type
      t.integer :recipient_id
      t.string :recipient_type
      t.string :message
      t.integer :status, :default => 0
      t.string :type_of

      t.timestamps null: false
    end
  end
end
