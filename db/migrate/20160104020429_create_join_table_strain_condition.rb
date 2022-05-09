class CreateJoinTableStrainCondition < ActiveRecord::Migration
  def change
    create_join_table :strains, :conditions do |t|
      # t.index [:strain_id, :condition_id]
      # t.index [:condition_id, :strain_id]
    end
  end
end
