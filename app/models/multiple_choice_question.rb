class MultipleChoiceQuestion < Question

  # Nested attributes
  accepts_nested_attributes_for :choices, :allow_destroy => true

end
