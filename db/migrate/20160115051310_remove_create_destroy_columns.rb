class RemoveCreateDestroyColumns < ActiveRecord::Migration
  def change
  	remove_column :careteams, :create
  	remove_column :careteams, :destroy
  end
end
