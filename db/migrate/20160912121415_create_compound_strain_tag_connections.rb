class CreateCompoundStrainTagConnections < ActiveRecord::Migration
  def change
    create_table :compound_strain_tag_connections do |t|
      t.integer :compound_strain_id
      t.integer :tag_id

      t.timestamps null: false
    end
  end
end
