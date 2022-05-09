class Symptom < ActiveRecord::Base

  # Associations
  has_many :disease_connections, :class_name => 'DiseaseSymptomConnection', :dependent => :destroy
  has_many :diseases, :through => :disease_connections, :dependent => :destroy

  # Encryptable columns
  has_encrypted_column :name

  # Validations
  validates_presence_of :name
end
