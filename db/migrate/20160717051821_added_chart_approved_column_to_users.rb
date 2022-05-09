class AddedChartApprovedColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :chart_approved, :boolean
  end
end
