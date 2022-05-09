class ChangeCareTeamRelation < ActiveRecord::Migration
  def change
    remove_column :careteams, :user_id, :integer
    remove_column :careteams, :physician_id, :integer
    add_column :careteams, :patient_id, :integer
  end
end
