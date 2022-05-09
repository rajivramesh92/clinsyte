class RangeBasedQuestion < Question

  # Validations
  validates_presence_of :min_range
  validates_presence_of :max_range

end
