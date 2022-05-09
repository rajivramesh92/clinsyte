class Api::V1::PhysiciansController < Api::V1::BaseController
  before_action :set_physician, :only => [ :slots, :make_primary, :unavailable_slots ]
  before_action :validate_member, :only => [ :make_primary ]
  authorize_resource :class => "User"

  def update
    if current_user.update(update_params)
      success_serializer_responder("Profile updated successfully")
    else
      error_serializer_responder(current_user)
    end
  end

  def slots
    if params[:include_busy]
      success_serializer_responder(@physician, PhysicianSlotsSerializer)
    else
      success_serializer_responder(@physician.slots, SlotSerializer)
    end
  end

  def make_primary
    @careteam.make_primary!(@physician)
    success_serializer_responder("Primary physician changed successfully")
  end

  def unavailable_slots
    success_serializer_responder(@physician.unavailable_slots, SlotSerializer)
  end

  private

  def update_params
    params.require(:physician).permit(:license_id, :expiry) rescue {}
  end

  def set_physician
    begin
      @physician = User.physicians.find(params[:id])
    rescue
      error_serializer_responder('Invalid user')
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
