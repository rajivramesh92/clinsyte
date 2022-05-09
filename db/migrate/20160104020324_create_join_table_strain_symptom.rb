class CreateJoinTableStrainSymptom < ActiveRecord::Migration
  def change
    create_join_table :strains, :symptoms do |t|
      # t.index [:strain_id, :symptom_id]
      # t.index [:symptom_id, :strain_id]
    end
  end
end
