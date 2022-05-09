class CreateTemplateData < ActiveRecord::Migration
  def change
    create_table :template_data do |t|
      t.string :message
      t.integer :template_id

      t.timestamps null: false
    end
  end
end
