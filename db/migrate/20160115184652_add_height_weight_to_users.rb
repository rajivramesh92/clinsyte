class AddHeightWeightToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :height, :string
  	add_column :users, :weight, :integer
  end
end
