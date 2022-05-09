class AddTypeAndDateToSlot < ActiveRecord::Migration
  def change
    add_column :slots, :type, :string, :default => 'AvailableSlot'
    add_column :slots, :date, :date
  end
end
