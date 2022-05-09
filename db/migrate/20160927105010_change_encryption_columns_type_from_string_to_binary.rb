class ChangeEncryptionColumnsTypeFromStringToBinary < ActiveRecord::Migration
  def change
    change_column :answers, :value, :string
    change_column :choices, :option, "bytea USING option::bytea"
    change_column :conditions, :name, "bytea USING name::bytea"
    change_column :answers, :description, "bytea USING description::bytea"
    change_column :medications, :name, "bytea USING name::bytea"
    change_column :answers, :value, "bytea USING value::bytea"
    change_column :selected_options, :option, "bytea USING option::bytea"
    change_column :symptoms, :name, "bytea USING name::bytea"
  end
end
