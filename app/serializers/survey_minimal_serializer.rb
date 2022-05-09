class SurveyMinimalSerializer < BaseSerializer

  attributes :id,
    :name,
    :editable,
    :status,
    :creator,
    :treatment_plan_dependent

  private

  def creator
    UserMinimalSerializer.new(object.creator).as_json
  end

  def editable
    object.is_editable?
  end

end