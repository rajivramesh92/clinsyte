module Concerns
  module SurveyParameterMapper

  # ToDo => Refactor and make it functional
  def customized_survey_params
    survey_parameters = survey_params
    questions = survey_parameters[:questions_attributes] rescue []
    questions.each do | question |
      category = question.delete(:category)
      if category == 'descriptive'
        question[:type] = 'DescriptiveQuestion'
      elsif category == 'multiple_choice'
        question[:type] = 'MultipleChoiceQuestion'
        question[:choices_attributes] = ( question.delete(:attrs) || [] ) rescue nil
      elsif category == 'range_based'
        question[:type] = 'RangeBasedQuestion'
        range = ( question.delete(:attrs) || [] ) rescue nil
        question[:min_range] = range[:min].to_i
        question[:max_range] = range[:max].to_i
      elsif category == 'list_driven'
        question[:type] = 'ListDrivenQuestion'
        attributes = ( question.delete(:attrs) || [] ) rescue nil # check if list exists
        question[:list_id] = attributes[:list_id]
        question[:category] = attributes[:category]
      end
    end

    survey_parameters
  end

  end
end