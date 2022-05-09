class ChangePhoneNumberFromStringToBigintInUsers < ActiveRecord::Migration
  def change
    remove_column :users, :phone_number, :string
    add_column :users, :phone_number, :bigint
  end
end
