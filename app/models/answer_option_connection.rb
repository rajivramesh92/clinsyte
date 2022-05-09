class AnswerOptionConnection < ActiveRecord::Base

  # Assosiations
  belongs_to :answer
  belongs_to :option

  # Validations
  validates_presence_of :answer
  validates_presence_of :option
  validate :option_is_valid?

  private

  def option_is_valid?
    valid_options = answer.question.options
    errors.add(:option, "is Invalid") unless valid_options.include?(option)
  end

end
