class CreateJoinTableStrainEffect < ActiveRecord::Migration
  def change
    create_join_table :strains, :effects do |t|
      # t.index [:strain_id, :effect_id]
      # t.index [:effect_id, :strain_id]
    end
  end
end
