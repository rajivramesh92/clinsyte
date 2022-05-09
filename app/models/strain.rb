class Strain < ActiveRecord::Base
  attr_accessor :effect_scores, :side_effect_scores

  # Associations
  belongs_to :category
  has_many :compound_strains
  has_many :compounds, :through => :compound_strains
  has_many :tags, :through => :compounds
  has_many :treatment_plan_therapies, :dependent => :destroy
  has_many :templates

  # Validations
  validates_presence_of :name, :brand_name, :category

end
