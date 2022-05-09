class Api::V1::CareteamsController < Api::V1::BaseController

  include ActivitiesHelper

  authorize_resource :only => :summary
  before_filter :load_member, :only => :remove_member
  before_filter :validate_email, :only => :invite_patient
  load_resource :only => [ :remove_member, :activities ]

  def remove_member
    if @careteam.members.include?(@user)
      @careteam.remove_member(@user)
      success_serializer_responder('Removed from careteam successfully')
    elsif @careteam.cancel_invite(@user, true)
      success_serializer_responder('Cancelled the careteam invite successfully')
    else
      error_serializer_responder('Invalid member')
    end
  end

  def activities
    records = filter_records(@careteam.all_audits)
    success_serializer_responder(paginate(records), AuditSerializer)
  end

  # EndPoint to return all the Careteams for a User
  def index
    if current_user.patient?
      success_serializer_responder(current_user.careteam, CareteamSerializer)
    else
      success_serializer_responder(current_user.careteams, CareteamSerializer)
    end
  end

  # Endpoint to return Careteam details
  def summary
    success_serializer_responder(current_user, CareteamSummarySerializer)
  end

  def invite_patient
    if User.where(:email => params[:email]).any?
      error_serializer_responder("Already user exists! Send a careteam request!")
    elsif ( patient = User.invite!(invite_params, current_user) rescue nil )
      request = Request.make_between(current_user, patient)
      success_serializer_responder(request, RequestSerializer)
    else
      error_serializer_responder("Sorry! Unable to send invitation")
    end
  end

  private

  def load_member
    @user = User.find(params[:member_id]) rescue current_user
  end

  def validate_email
    unless ( params[:email] =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i )
      error_serializer_responder("Email is invalid")
    end
  end

  def invite_params
    params.permit(:email, :first_name, :last_name)
  end

end
