class Genetic < ActiveRecord::Base

  # Associations
	belongs_to :patient, :class_name => 'User'
	has_many :variations, :dependent => :destroy

  # Validations
  validates_presence_of :name
  validates_presence_of :patient

  # Nested Attributes
  accepts_nested_attributes_for :variations, :allow_destroy => true

end
