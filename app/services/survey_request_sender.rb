class SurveyRequestSender

  def initialize(sender, patients, survey)
    @sender = sender
    @patients = patients rescue []
    @survey = survey
  end

  def send
    @patients.each do |patient|
      patient_user = User.find(patient.to_i) rescue nil
      @sender.sent_surveys.create(:receiver => patient_user, :survey => @survey)
      SurveyNotificationSender.perform_async(patient)
    end
  end

end