class AddDefaultValueToStatus < ActiveRecord::Migration
  def change
  	change_column :notifications, :status, :integer, :default => 0
  end
end
