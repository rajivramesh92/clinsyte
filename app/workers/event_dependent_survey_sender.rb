# Worker to send the survey to the patient once he takes the therapy for a Treatment Plan

class EventDependentSurveySender
  include Sidekiq::Worker

  sidekiq_options :retry => 3, :queue => :surveys, :backtrace => true

  def perform(sender_id, patient, survey_id)
    sender = User.find(sender_id) rescue nil
    survey = Survey.find(survey_id) rescue nil
    SurveyRequestSender.new(sender, patient, survey).send
  end

end