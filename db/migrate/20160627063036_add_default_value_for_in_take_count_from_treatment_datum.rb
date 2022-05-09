class AddDefaultValueForInTakeCountFromTreatmentDatum < ActiveRecord::Migration
  def change
    change_column :treatment_data, :intake_count, :integer, :default => 0
  end
end
