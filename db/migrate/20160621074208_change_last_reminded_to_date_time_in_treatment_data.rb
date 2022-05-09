class ChangeLastRemindedToDateTimeInTreatmentData < ActiveRecord::Migration
  def change
    remove_column :treatment_data, :last_reminded, :time
    add_column :treatment_data, :last_reminded, :datetime
  end
end
