class CreateCareteams < ActiveRecord::Migration
  def change
    create_table :careteams do |t|
      t.integer :user_id
      t.integer :physician_id
      t.string :create
      t.string :destroy

      t.timestamps null: false
    end
  end
end
