class CompoundStrainTagConnection < ActiveRecord::Base

  # Associations
  belongs_to :compound_strain
  belongs_to :tag

  # Validations
  validates_presence_of :compound_strain
  validates_presence_of :tag

end
