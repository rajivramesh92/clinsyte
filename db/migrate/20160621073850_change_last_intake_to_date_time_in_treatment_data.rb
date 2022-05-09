class ChangeLastIntakeToDateTimeInTreatmentData < ActiveRecord::Migration
  def change
    remove_column :treatment_data, :last_intake, :time
    add_column :treatment_data, :last_intake, :datetime
  end
end
