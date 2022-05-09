class Api::V1::ConditionsController < Api::V1::BaseController
  include Concerns::Searchable

  @@klass = Condition
  @@serializer = ConditionSerializer

  def list
    conditions = Condition.all
    success_serializer_responder(conditions, ConditionSerializer)
  end

end
