class Template < ActiveRecord::Base

  # Assosiations
  has_one :template_data, :class_name => 'TemplateDatum', :dependent => :destroy
  belongs_to :strain
  belongs_to :creator, :class_name => 'User'

  # Validations
  validates_presence_of :strain, :creator, :name
  validates_uniqueness_of :name

  # Enumeration
  enum :access_level => [
    :personal,
    :shared
  ]

  # Nested attributes
  accepts_nested_attributes_for :template_data, :allow_destroy => true

  def self.available_with?(name)
    Template.where("name ilike ?", "%#{name}%").blank?
  end

end
