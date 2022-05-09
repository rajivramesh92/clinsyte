class CreateDiseasesStrains < ActiveRecord::Migration
  def change
    create_table :diseases_strains do |t|
      t.references :disease, index: true, foreign_key: true
      t.references :strain, index: true, foreign_key: true
    end
  end
end
