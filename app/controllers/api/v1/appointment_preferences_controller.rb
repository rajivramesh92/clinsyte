class Api::V1::AppointmentPreferencesController < Api::V1::BaseController

  load_and_authorize_resource

  def toggle_auto_confirm
    appointment_preference = current_user.appointment_preference
    if appointment_preference.update(update_params)
      success_serializer_responder('Appointment preferences updated successfully')
    else
      error_serializer_responder(@appointment)
    end
  end

  private

  def update_params
    params.require(:appointment_preference).permit(:auto_confirm)
  end

end
