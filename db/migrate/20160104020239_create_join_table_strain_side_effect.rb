class CreateJoinTableStrainSideEffect < ActiveRecord::Migration
  def change
    create_join_table :strains, :side_effects do |t|
      # t.index [:strain_id, :side_effect_id]
      # t.index [:side_effect_id, :strain_id]
    end
  end
end
