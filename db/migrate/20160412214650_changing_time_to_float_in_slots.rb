class ChangingTimeToFloatInSlots < ActiveRecord::Migration
  def change
    remove_column :slots, :from_time, :time
    add_column :slots, :from_time, :float
    remove_column :slots, :to_time, :time
    add_column :slots, :to_time, :float
  end
end
