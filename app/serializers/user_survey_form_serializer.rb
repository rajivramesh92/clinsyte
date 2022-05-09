class UserSurveyFormSerializer < BaseSerializer

  attributes :id,
    :survey,
    :state,
    :sender,
    :receiver,
    :sent_at,
    :submitted_at,
    :started_at

  private

  def survey
    SurveyMinimalSerializer.new(object.survey).as_json
  end

  def sender
    UserMinimalSerializer.new(object.sender).as_json
  end

  def receiver
    UserMinimalSerializer.new(object.receiver).as_json
  end

end