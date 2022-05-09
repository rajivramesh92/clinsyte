# Worker to send SMS for the Survey Requests

class SurveyNotificationSender
  include Sidekiq::Worker

  # Sidekiq config for this worker
  sidekiq_options :retry => 1, :queue => :sms, :backtrace => true

  def perform(patient_id)
    patient = User.find(patient_id) rescue nil
    return unless patient

    TwilioMessageSender.send_survey_notification(patient.formatted_phone_number)
  end

end