class Api::V1::AppointmentsController < Api::V1::BaseController

  before_action :validate_physician, :only => :create
  before_action :check_status, :only => :change_status
  before_action :load_appointment, :only => :create
  load_and_authorize_resource
  before_action :validate_appointment, :only => [ :cancel, :change_status, :destroy ]

  # Endpoint to show all the
  # scheduled appointments for a patient and received appointments for a physician
  def index
    render_appointments('accepted')
  end

  def pending
    render_appointments('pending')
  end

  # Endpoint to create appointments by a patient
  def create
    appointment = current_user.scheduled_appointments.new(create_params)
    if appointment.save
      success_serializer_responder(appointment, AppointmentSerializer)
    else
      error_serializer_responder(appointment)
    end
  end

  # Endpoint to update appointment timings by a patient
  def update
    if @appointment.update(update_params)
      success_serializer_responder(@appointment, AppointmentSerializer)
    else
      error_serializer_responder(@appointment)
    end
  end

  # Enpoint for deleting appointment by patient if not yet confirmed
  def destroy
    if @appointment.destroy
      success_serializer_responder("Appointment removed successfully")
    else
      error_serializer_responder(@appointment)
    end
  end

  # Endpoint to accept or decline the appointment request
  def change_status
    @appointment.send("#{params[:status]}!")
    if @appointment.accepted?
      success_serializer_responder("Appointment request accepted successfully")
    else
      success_serializer_responder("Appointment request rejected successfully")
    end
  end

  # Endpoint to cancel the appointment
  def cancel
    if @appointment.cancelled?
      error_serializer_responder('Appointment already cancelled')
    elsif @appointment.cancelled!
      success_serializer_responder('Appointment cancelled successfully')
    else
      error_serializer_responder('Something went wrong, please try again')
    end
  end

  private

  def create_params
    params.require(:appointment).permit(
      :physician_id,
      :date,
      :from_time,
      :to_time
    )
  end

  def update_params
    params.permit(:date, :from_time, :to_time)
  end

  def validate_physician
    physician = User.physicians.find(create_params[:physician_id]) rescue nil
    error_serializer_responder('Invalid physician') if physician.nil?
  end

  def check_status
    unless params[:status].eql?("accept") || params[:status].eql?("decline")
      error_serializer_responder("Invalid Status")
    end
  end

  def render_appointments(status)
    if current_user.physician?
      success_serializer_responder(current_user.received_appointments.send(status), AppointmentSerializer)
    else
      success_serializer_responder(current_user.scheduled_appointments.send(status), AppointmentSerializer)
    end
  end

  def load_appointment
    @appointment = Appointment.new(create_params)
  end

  def validate_appointment
    result = current_user.scheduled_appointments.exists?(@appointment.id) if current_user.patient?
    result = current_user.received_appointments.exists?(@appointment.id) if current_user.physician?
    error_serializer_responder('Appointment does not belongs to the user') if result.blank?
  end

end
