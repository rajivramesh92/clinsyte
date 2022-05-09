class AddGenderAndEthnicityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string
    add_column :users, :ethnicity, :string
  end
end
