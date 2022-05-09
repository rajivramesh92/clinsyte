class MultipleChoiceAnswer < Answer

  # Assosiations
  belongs_to :choice

  # Validations
  validates_presence_of :choice

  # Callbacks
  before_save :choice_is_valid?

  private

  def choice_is_valid?
    errors.add(:choice, "is Invalid") unless question.choices.include?(choice)
  end

end
