class Api::V1::TreatmentPlansController < Api::V1::BaseController

  load_and_authorize_resource

  # Endpoint to change the owner of an Orphaned treatment Plan
  # by a physician member of patients careteam
  def change_owner
    if @treatment_plan.orphaned? and current_user_is_a_careteam_member?
      @treatment_plan.update(:creator => current_user)
      success_serializer_responder(@treatment_plan.reload, TreatmentPlanSerializer)
    else
      error_serializer_responder('Treatment Plan Owner can not be switched')
    end
  end

  # Endpoint to remove an orphaned treatment plan
  # by a member of patients caretem
  def remove_treatment_plan
    if @treatment_plan.orphaned? and current_user_is_a_careteam_member?
      @treatment_plan.destroy
      success_serializer_responder('Treatment Plan removed successfully')
    else
      error_serializer_responder('Treatment Plan can not be removed')
    end
  end

  private

  # Method to check if current user is a carteam member of treatment plan patient's careteam
  def current_user_is_a_careteam_member?
    current_user.associated_patients.include?(@treatment_plan.patient.id)
  end

end
