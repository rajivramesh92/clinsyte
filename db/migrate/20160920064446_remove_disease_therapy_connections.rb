class RemoveDiseaseTherapyConnections < ActiveRecord::Migration
  def change
    drop_table :disease_therapy_connections
  end
end
