class Api::V1::PatientsController < Api::V1::BaseController

  before_action :set_physician, :only => [ :select_physician, :make_primary ]
  before_action :validate_member, :only => [ :make_primary ]
  authorize_resource :class => "Careteam", :only => [:select_physician, :deselect_physician, :physician]

  # This method takes physicians id and updates it for current patient
  def select_physician
    current_user.careteam.add_physician(@physician)
    success_serializer_responder("Physician updated successfully")
  end

  # This method de-selects the currently assigned physician if it is already selected
  def deselect_physician
    if current_user.careteam.members.any?
      current_user.careteam.remove_member(@physician)
      success_serializer_responder("Physician deselected successfully")
    else
      error_serializer_responder("Need to select a physician before de-selecting")
    end
  end

  # This method returns the currently assigned physician for the patient
  def physician
    unless current_user.careteam.members.any?
      error_serializer_responder("No physician selected yet")
    else
      success_serializer_responder(current_user.careteam.primary_physician, UserSerializer)
    end
  end

  def careteam
    patient = User.find(params[:id])
    success_serializer_responder(patient.careteam, CareteamWithMembersSerializer)
  end

  def make_primary
    @careteam.make_primary!(@physician)
    success_serializer_responder("Primary physician changed successfully")
  end

  private

  def physicians_params
    params.permit(:id , :physician_id)
  end

  # Method to check whether user to be assigned as the physician is a physician or not
  def set_physician
    begin
      @physician = User.physicians.find(physicians_params[:physician_id].to_i)
    rescue
      error_serializer_responder("Invalid physician")
    end
  end

  # Method to validate if the user is a member of careteam
  def validate_member
    @careteam = current_user.careteam
    unless @careteam.members.include?(@physician)
      error_serializer_responder("Physician needs to be a member of the Careteam")
    end
  end

end

