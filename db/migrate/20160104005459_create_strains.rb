class CreateStrains < ActiveRecord::Migration
  def change
    create_table :strains do |t|
      t.string :name
      t.string :slug
      t.integer :reviews

      t.references :category, index: true, foreign_key: true

      t.json :beta_myrcene, default: { high: 0, low: 0, avg: 0, range: 0 }, null: false
      t.json :cbg, default: { high: 0, low: 0, avg: 0, range: 0 }, null: false
      t.json :cbd, default: { high: 0, low: 0, avg: 0, range: 0 }, null: false
      t.json :cbc, default: { high: 0, low: 0, avg: 0, range: 0 }, null: false
      t.json :cbn, default: { high: 0, low: 0, avg: 0, range: 0 }, null: false
      t.json :cbl, default: { high: 0, low: 0, avg: 0, range: 0 }, null: false
      t.json :thcv, default: { high: 0, low: 0, avg: 0, range: 0 }, null: false
      t.json :d_limonene, default: { high: 0, low: 0, avg: 0, range: 0 }, null: false
      t.json :beta_caryophyllene, default: { high: 0, low: 0, avg: 0, range: 0 }, null: false
      t.json :linalool, default: { high: 0, low: 0, avg: 0, range: 0 }, null: false
      t.json :thc, default: { high: 0, low: 0, avg: 0, range: 0 }, null: false
      t.json :a_pinene, default: { high: 0, low: 0, avg: 0, range: 0 }, null: false

      t.timestamps null: false
    end
  end
end
