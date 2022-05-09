class CreateEntityTagConnections < ActiveRecord::Migration
  def change
    create_table :entity_tag_connections do |t|
      t.integer :taggable_entity_id
      t.string :taggable_entity_type
      t.integer :tag_id

      t.timestamps null: false
    end
  end
end
