class SurveySerializer < BaseSerializer

  attributes :id,
    :name,
    :treatment_plan_dependent,
    :editable,
    :questions

  private

  def name
    object.name.to_s.capitalize
  end

  def editable
    object.is_editable?
  end

  def questions
    serialize_collection(object.questions.active, QuestionSerializer)
  end

end