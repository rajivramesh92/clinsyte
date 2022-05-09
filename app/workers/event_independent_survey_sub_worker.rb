class EventIndependentSurveySubWorker

  include Sidekiq::Worker

  # Sidekiq config for this worker
  sidekiq_options :retry => 3, :queue => :surveys, :backtrace => true

  def perform(receipient, survey_config)
    survey_config = SurveyConfiguration.find(survey_config)
    return unless survey_config.present?

    sender = survey_config.sender
    survey = survey_config.survey

    SurveyRequestSender.new(sender, [ receipient ], survey).send
  end

end