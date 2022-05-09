class RangeBasedAnswer < Answer

  has_encrypted_column :value

  # Validations
  validates_presence_of :value
  validates_numericality_of :value

  # Callbacks
  before_save :value_is_valid?

  private

  def value_is_valid?
    valid_range = eval("#{question.min_range}..#{question.max_range}")
    unless valid_range.include?(value.to_i)
      errors.add(:value, "out of range")
      false
    end
  end

end
