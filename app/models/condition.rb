class Condition < ActiveRecord::Base

  # Associations
  has_many :tag_connections, {
    :as => :taggable_entity,
    :class_name => EntityTagConnection,
    :dependent => :destroy
  }

  has_many :diseases, :dependent => :destroy
  has_many :tags, :through => :tag_connections

  # Encryptable columns
  has_encrypted_column :name

  # Validations
  validates_presence_of :name

end
