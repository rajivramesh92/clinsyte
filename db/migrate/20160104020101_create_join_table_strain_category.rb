class CreateJoinTableStrainCategory < ActiveRecord::Migration
  def change
    create_join_table :strains, :categories do |t|
      # t.index [:strain_id, :category_id]
      # t.index [:category_id, :strain_id]
    end
  end
end
