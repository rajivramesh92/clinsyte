class AddStatusColumnToOptions < ActiveRecord::Migration
  def change
    add_column :options, :status, :integer, :default => 0
  end
end
