class RemoveTagIdFromCompounds < ActiveRecord::Migration
  def change
    remove_column :compounds, :tag_id
  end
end
