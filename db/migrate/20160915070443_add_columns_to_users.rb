class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :preferred_device, :integer
    add_column :users, :time_zone, :string
  end
end
