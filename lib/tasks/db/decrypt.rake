require 'pgcrypto'
namespace :db do
  task :decrypt => :environment do
    encryptable_tables = {
      'answers' => ['value', 'description'],
      'choices' => ['option'],
      'conditions' => ['name'],
      'medications' => ['name'],
      'selected_options' => ['option'],
      'symptoms' => ['name']
    }
    connection = ActiveRecord::Base.connection
    key = PGCrypto.keys.public_key
    encryptable_tables.each do |table_name, encryptable_fields|
      encryptable_fields.each do |column|
        PGCrypto::Crypt.decrypt_column(table_name, column, key)
      end
    end
  end
end
