class EventDependentSurveySerializer < BaseSerializer

  attributes :id,
    :survey,
    :time,
    :receipients

  private

  def survey
    {
      :id => Survey.unscoped { object.survey.id },
      :name => object.survey.name
    }
  end

  def receipients
    survey_receivers = object.receipients
    patients = survey_receivers.map { |survey_receiver| survey_receiver.receiver }
    serialize_collection(patients, UserMinimalSerializer).as_json
  end

end