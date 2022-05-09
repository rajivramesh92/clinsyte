class Question < ActiveRecord::Base

  # Enumerations
  enum :status => [
    :active,
    :inactive
  ]

  default_scope { order(:created_at => :asc, :id => :asc) }

  # Assosiation
  belongs_to :survey, :inverse_of => :questions
  has_many :answers, :inverse_of => :question
  has_many :choices, :inverse_of => :question, :dependent => :destroy
  belongs_to :list

  # Delegate
  delegate :options, :to => :list

  # Validations
  validates_presence_of :description
  validates_presence_of :survey

  # Instance Methods
  def rails_admin_default_object_label_method
    description
  end

  # Instance Methods
  def rails_admin_default_object_label_method
    description
  end

  # Methods to check Question type
  def descriptive?
    type.eql?('DescriptiveQuestion')
  end

  def multiple_choice?
    type.eql?('MultipleChoiceQuestion')
  end

  def range_based?
    type.eql?('RangeBasedQuestion')
  end

  def list_driven?
    type.eql?('ListDrivenQuestion')
  end

end
