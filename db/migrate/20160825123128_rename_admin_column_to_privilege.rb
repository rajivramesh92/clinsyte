class RenameAdminColumnToPrivilege < ActiveRecord::Migration
  def change
    remove_column :users, :admin
    add_column :users, :privilege, :integer
  end
end
