class AddAccessLevelToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :access_level, :integer, :default => 0
  end
end
