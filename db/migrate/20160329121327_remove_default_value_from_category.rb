class RemoveDefaultValueFromCategory < ActiveRecord::Migration
  def change
  	change_column :notifications, :category, :string, :default => nil
  end
end
