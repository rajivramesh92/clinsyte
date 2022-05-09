class TemplateDatum < ActiveRecord::Base

  # Assosiations
  belongs_to :template

  # Validations
  validates_presence_of :message
end
