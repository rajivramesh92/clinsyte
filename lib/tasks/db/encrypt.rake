require 'pgcrypto'
namespace :db do
  task :encrypt => :environment do
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
      klass = Class.new(ActiveRecord::Base).tap do | obj |
        obj.table_name = table_name
      end

      klass.find_each(batch_size: 10000) do |row|
        encryptable_fields.each do |column|
          value = row.send(column)
          if value.blank?
            connection.execute("update #{table_name} set #{column} = NULL where id = '#{row.id}'")
          else
            query = "SELECT " + PGCrypto::Crypt.encrypt_string(value, key) + ";"
            enc_data = connection.execute(query)[0]["pgp_sym_encrypt"]
            begin
              connection.execute("update #{table_name} set #{column} = \"#{enc_data}\" where id = '#{row.id}'")
            rescue Exception => e
              puts "======================"
              puts row.id
              puts "======================"
            end
          end
        end
      end
    end
  end
end
