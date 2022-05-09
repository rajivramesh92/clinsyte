class Option < ActiveRecord::Base

  # Enums
  enum :status => [
    :active,
    :inactive
  ]

  # Default scope
  default_scope { active.order(:created_at => :asc, :id => :asc) }

  # Assosiations
  belongs_to :list, :inverse_of => :options

  # Validations
  validates_presence_of :name
  validates_presence_of :list

end
