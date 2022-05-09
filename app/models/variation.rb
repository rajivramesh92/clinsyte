class Variation < ActiveRecord::Base
  belongs_to :genetic
  has_many :phenotypes, :dependent => :destroy

  #Validations
  validates_presence_of :name
  validates_presence_of :chromosome
  validates_presence_of :position
  validates_presence_of :genotype
  validates_presence_of :maf
  validates_presence_of :genetic

  # Nested Attributes
  accepts_nested_attributes_for :phenotypes, :allow_destroy => true

end
