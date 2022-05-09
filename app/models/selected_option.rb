class SelectedOption < ActiveRecord::Base

  # Assosiations
  belongs_to :list_driven_answer, :inverse_of => :selected_options

  # Encryptable columns
  has_encrypted_column :option

  # Validations
  validates_presence_of :option
  validates_uniqueness_of :list_driven_answer, :if => :single_select_question?

  # Callbacks
  before_save :validate_question_type

  private

  # Validates if the List Based Question is Single select or Multi select
  def single_select_question?
    question_category = self.list_driven_answer.question.category rescue nil
    question_category == 'single_select'
  end

  # Validates if the Question is List Driven
  def validate_question_type
    question_type = self.list_driven_answer.question.type rescue nil
    question_type == 'ListDrivenQuestion'
  end

end
