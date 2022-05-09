class Compound < ActiveRecord::Base

  # Associations
  has_many :tag_connections, {
    :as => :taggable_entity,
    :class_name => EntityTagConnection,
    :dependent => :destroy
  }

  has_many :compound_strains
  has_many :strains, :through => :compound_strains
  has_many :tags, :through => :tag_connections

  # Validations
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false

end
