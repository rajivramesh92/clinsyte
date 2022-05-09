class DropTableCompoundsStrains < ActiveRecord::Migration
  def change
    drop_table :compounds_strains
  end
end
