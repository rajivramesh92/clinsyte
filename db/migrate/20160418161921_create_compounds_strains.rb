class CreateCompoundsStrains < ActiveRecord::Migration
  def change
    create_table :compounds_strains do |t|
      t.integer :compound_id
      t.integer :strain_id
    end
  end
end
