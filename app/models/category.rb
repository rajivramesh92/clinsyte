class Category < ActiveRecord::Base

  # Assosiations
  has_many :strains

  # Validations
  validates_uniqueness_of :name

end
