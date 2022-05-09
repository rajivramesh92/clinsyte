class AddEntityIdAndTypeToFieldValue < ActiveRecord::Migration
  def change
    add_column :field_values, :entity_id, :integer
    add_column :field_values, :entity_type, :string
  end
end
