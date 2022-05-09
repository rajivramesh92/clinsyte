class Phenotype < ActiveRecord::Base
  belongs_to :variation

  #Validations
  validates_presence_of :name
  validates_presence_of :variation

end
