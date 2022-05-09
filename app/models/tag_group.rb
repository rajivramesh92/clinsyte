class TagGroup < ActiveRecord::Base

  # Assosiations
  has_many :tags

  # Validations
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false

end
