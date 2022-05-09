# Worker to send Reminders to the patients for taking their therapy

class ReminderSenderWorker
  include Sidekiq::Worker

  # Sidekiq config for this worker
  sidekiq_options :retry => 3, :queue => :reminders, :backtrace => true

  def perform(type, data_id, phone_number)
    data = TreatmentDatum.find(data_id) rescue nil
    treatment_plan_therapy = data.treatment_plan_therapy rescue nil
    treatment_plan = treatment_plan_therapy.treatment_plan rescue nil
    if type == 'snooze_reminder'
      data.update(:last_reminded => DateTime.now)
    end

    PrivatePub.publish_to "/messages/#{treatment_plan.patient.id}", :alert => { :plan_id => treatment_plan.id,
     :therapy_id => treatment_plan_therapy.id, :message => "It's time to take the medicine - '#{treatment_plan_therapy.strain.name}'" }
    TwilioMessageSender.send_reminder(phone_number, treatment_plan_therapy.strain.name) rescue nil
  end

end