class SurveyRequestSerializer < BaseSerializer

  attributes :id,
    :state,
    :sender,
    :receiver,
    :sent_at,
    :submitted_at,
    :started_at,
    :survey

  private

  def survey
    if object.submitted?
      {
        :id => object.survey.id,
        :name => object.survey.name,
        :attributes => object.survey.questions.map do |question|
          {
            :question => QuestionSerializer.new(question).as_json,
            :response => get_response(question)
          }
        end
      }
    else
      SurveySerializer.new(object.survey).as_json
    end
  end

  def sender
    UserMinimalSerializer.new(object.sender).as_json
  end

  def receiver
    UserMinimalSerializer.new(object.receiver).as_json
  end

  private

  def get_response(question)
    response_object = object.answers.find_by(:question => question)
    return if response_object.nil?
    response_type = response_object.type
    response = nil
    if response_type == "DescriptiveAnswer"
      response = response_object.try(:description)
    elsif response_type == "MultipleChoiceAnswer"
      response = ChoiceSerializer.new(Choice.find(response_object.try(:choice_id))).as_json
    elsif response_type == "RangeBasedAnswer"
      response = response_object.try(:value)
    elsif response_type == "ListDrivenAnswer"
      response = response_object.try(:selected_options).map(&:option)
    end

    response
  end

end