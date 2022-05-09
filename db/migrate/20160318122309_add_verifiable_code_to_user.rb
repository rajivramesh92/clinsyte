class AddVerifiableCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :verification_code, :integer
    add_column :users, :verification_status, :json, :default => {}
  end
end
