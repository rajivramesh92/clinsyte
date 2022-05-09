class ChangeCategoryToIntegerInNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :category, :string
    add_column :notifications, :category, :integer, :default => 0
  end
end
