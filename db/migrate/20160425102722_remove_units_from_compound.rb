class RemoveUnitsFromCompound < ActiveRecord::Migration
  def change
    remove_column :compounds, :high, :decimal
    remove_column :compounds, :low, :decimal
    remove_column :compounds, :average, :decimal
  end
end
