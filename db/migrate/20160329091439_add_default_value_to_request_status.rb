class AddDefaultValueToRequestStatus < ActiveRecord::Migration
  def change
    change_column :requests, :status, :integer, :default => 0
  end
end
