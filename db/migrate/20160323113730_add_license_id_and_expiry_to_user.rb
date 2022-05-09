class AddLicenseIdAndExpiryToUser < ActiveRecord::Migration
  def change
    add_column :users, :license_id, :string
    add_column :users, :expiry, :date
  end
end
