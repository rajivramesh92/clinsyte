class Choice < ActiveRecord::Base

  # Assosiations
  belongs_to :question, :inverse_of => :choices

  # Encryptable columns
  has_encrypted_column :option

  # Validations
  validates_presence_of :question
  validates_presence_of :option

  # Callbacks
  before_save :validate_question_category

  default_scope { order(:created_at => :asc, :id => :asc) }

  private

  # Checks if the Question Category is Multiple choice
  def validate_question_category
    unless self.question.type == 'MultipleChoiceQuestion'
      self.errors.add(:question, "must be of category-'Multiple Choice' to add options" )
      false
    end
  end
end
