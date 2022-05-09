class CreateCareteamMemberships < ActiveRecord::Migration
  def change
    create_table :careteam_memberships do |t|
      t.references :careteam, :index => true, :foreign_key => true
      t.references :member, :index => true
      t.integer :level, :default => 0

      t.timestamps null: false
    end
  end
end
