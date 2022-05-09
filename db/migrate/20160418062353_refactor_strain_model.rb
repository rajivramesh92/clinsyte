class RefactorStrainModel < ActiveRecord::Migration
  def change
    # Deletions
    remove_column :strains, :slug, :string
    remove_column :strains, :reviews, :integer
    remove_column :strains, :beta_myrcene, :json
    remove_column :strains, :cbg, :json
    remove_column :strains, :cbd, :json
    remove_column :strains, :cbc, :json
    remove_column :strains, :cbn, :json
    remove_column :strains, :cbl, :json
    remove_column :strains, :thcv, :json
    remove_column :strains, :d_limonene, :json
    remove_column :strains, :beta_caryophyllene, :json
    remove_column :strains, :linalool, :json
    remove_column :strains, :thc, :json
    remove_column :strains, :a_pinene, :json

    # Additions
    add_column :strains, :brand_name, :string
    add_column :strains, :dosage, :string
  end
end
