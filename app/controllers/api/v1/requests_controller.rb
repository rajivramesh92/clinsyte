class Api::V1::RequestsController < Api::V1::BaseController

  load_resource :only => [:show, :update]
  authorize_resource :only => [:create, :update, :index]

  before_action :set_recipient, :only => :create
  before_action :check_status, :only => :update
  before_action :check_if_already_a_member, :only => :create

  def index
    requests = paginate(current_user.received_requests.pending)
    success_serializer_responder(requests, RequestSerializer)
  end

  # Endpoint to create the request and notification when the recipient is selected
  def create
    request = Request.make_between(current_user, @recipient)
    if request.is_a?(ActiveRecord::Base)
      success_serializer_responder(request, RequestSerializer)
    else
      error_serializer_responder(request)
    end
  end

  # Endpoint to return the request for the given request id
  def show
    success_serializer_responder(@request , RequestSerializer)
  end

  # Endpoint to update the request with the status provided as parameter
  def update
    @request.send("#{params[:status]}!")
    if @request.accepted?
      success_serializer_responder(@request.reload, RequestSerializer)
    else
      success_serializer_responder(@request.reload, RequestSerializer)
    end
  end

  private

  def check_status
    unless params[:status].eql?("accept") || params[:status].eql?("decline")
      error_serializer_responder("Invalid Status")
    end
  end

  def set_recipient
    begin
      @recipient = User.find(create_params[:recipient_id].to_i)
    rescue
      error_serializer_responder("No such user exists to send the request")
    end
  end

  def update_params
    params.permit(:status, :id)
  end

  def create_params
    params.permit(:recipient_id)
  end

  # Checks if the recipient of the request is already a member of patients careteam
  def check_if_already_a_member
    if current_user.physician?
      is_a_member = current_user.associated_patients.include?(@recipient.id)
    elsif current_user.patient?
      is_a_member = current_user.careteam.members.include?(@recipient)
    end

    error_serializer_responder("#{@recipient.first_name} is already a member") if is_a_member
  end

end
