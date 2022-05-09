class AddCategoryColumnQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :category, :integer, :default => 0
  end
end
