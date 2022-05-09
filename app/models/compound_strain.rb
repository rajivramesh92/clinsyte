class CompoundStrain < ActiveRecord::Base

  # Associations
  belongs_to :compound
  belongs_to :strain
  has_many :tag_connections, {
    :class_name => CompoundStrainTagConnection,
    :dependent => :destroy
  }
  has_many :tags, :through => :tag_connections

  # Validations
  validates_presence_of :compound, :strain, :high, :low, :average
  validates_uniqueness_of :compound_id, :scope => :strain_id

end
