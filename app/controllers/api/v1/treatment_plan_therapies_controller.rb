class Api::V1::TreatmentPlanTherapiesController < Api::V1::BaseController

  authorize_resource
  before_filter :validate_treatment_plan
  before_filter :validate_treatment_therapy

  # Endpoint to take the Therapy by the Patient
  def take
    if @therapy.take_therapy
      success_serializer_responder("Dosage taken successfully")
    else
      error_serializer_responder("This dosage is an overdose as per prescription")
    end
  end

  # Endpoint to snooze the reminder time
  def snooze
    if @therapy.snoozable?
      @therapy.snooze_reminder
      success_serializer_responder('Therapy Reminder snoozed successfully')
    else
      error_serializer_responder('Therapy Reminder snoozing unsuccessfull')
    end
  end

  private

  # Method to verify the treatment plan belongs to patient
  def validate_treatment_plan
    @treatment_plan = current_user.treatment_plans.find(params[:treatment_plan_id])
    unless @treatment_plan.present?
      error_serializer_responder('No such treatment Plan')
    end
  end

  # Method to verify the treatment plan therapy
  def validate_treatment_therapy
    @therapy = @treatment_plan.therapies.find(params[:id])
    unless @therapy.present?
      error_serializer_responder("No such Therapy for the Treatment Plan")
    end
  end

end
