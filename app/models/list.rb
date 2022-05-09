class List < ActiveRecord::Base

  # Enums
  enum :status => [
    :active,
    :inactive
  ]

  # Default scope
  default_scope { active }

  # Assosiations
  has_many :options, :inverse_of => :list, :dependent => :destroy

  # Validations
  validates_presence_of :name

  # Nested Attributes
  accepts_nested_attributes_for :options, :allow_destroy => true

end
