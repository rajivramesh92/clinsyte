class QuestionSerializer < BaseSerializer

  attributes :id,
    :description,
    :category,
    :attrs

  private

  def attrs
    if object.type == "MultipleChoiceQuestion"
      object.choices.map do | choice |
        {
          :id => choice.id,
          :option => choice.option
        }
      end
    elsif object.type == "RangeBasedQuestion"
      {
        :min => object.min_range,
        :max => object.max_range
      }
    elsif object.type == "ListDrivenQuestion"
      list = List.unscoped { object.list }
      {
        :list => {
          :id => list.id,
          :name => list.name,
          :options => get_list_options
        },
        :category => object.category
      }
    else
      []
    end
  end

  def get_list_options
    object.options.map do | option |
      {
        :id => option.id,
        :option => option.name
      }
    end
  end

  # Mapping class name to strings
  def category
    if object.type == 'DescriptiveQuestion'
      'descriptive'
    elsif object.type == 'MultipleChoiceQuestion'
      'multiple_choice'
    elsif object.type == 'RangeBasedQuestion'
      'range_based'
    elsif object.type == 'ListDrivenQuestion'
      'list_driven'
    end
  end

end