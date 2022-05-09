class ChangeTherapyIdToStrainIdInDiseaseTherapyConnection < ActiveRecord::Migration
  def change
    rename_column :disease_therapy_connections, :therapy_id, :strain_id
  end
end
