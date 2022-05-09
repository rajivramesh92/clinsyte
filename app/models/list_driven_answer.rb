class ListDrivenAnswer < Answer

  # Assosiatons
  has_many :selected_options, {
    :inverse_of => :list_driven_answer,
    :dependent => :destroy
  }

  validates_presence_of :selected_options
  validate :options_for_single_select

  # Nested attributes
  accepts_nested_attributes_for :selected_options, :allow_destroy => true

  # Validating option counts for single_select questions
  def options_for_single_select
    if question.category.eql?(1) && selected_options.size > 1
      errors.add(:base, "Only one option can be selected")
    end
  end

end
