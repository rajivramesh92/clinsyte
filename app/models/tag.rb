class Tag < ActiveRecord::Base

  # Associations
  has_many :entity_connections, {
    :class_name => 'EntityTagConnection',
    :foreign_key => :tag_id
  }

  belongs_to :tag_group
  has_many :conditions, :through => :entity_connections, :source => :taggable_entity, :source_type => 'Condition'
  has_many :compounds, :through => :entity_connections, :source => :taggable_entity, :source_type => 'Compound'
  has_many :surveys, :through => :entity_connections, :source => :taggable_entity, :source_type => 'Survey'
  has_many :users, :through => :entity_connections, :source => :taggable_entity, :source_type => 'User'
  has_many :compound_strain_connections, {
    :class_name => CompoundStrainTagConnection,
    :dependent => :destroy
  }

  # Validations
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :tag_group

end
