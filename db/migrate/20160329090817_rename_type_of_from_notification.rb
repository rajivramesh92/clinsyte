class RenameTypeOfFromNotification < ActiveRecord::Migration
  def change
    remove_column :notifications, :type_of, :string
    add_column :notifications, :category, :string, :default => 0
  end
end
