module ApplicationHelper

  def get_state(user = current_user)
    state = {}
    return state unless user.present?

    # State of the user to return
    state.merge!(auth).merge!(notifications)

    unless user.patient?
      state.merge!(careteams_and_invites).merge!(appointment_preference)
    else
      state.merge!(qr_code).merge!(careteam_and_its_data.to_h)
    end

    state.merge!(surveys.to_h)

    state.merge!(rt_params.to_h)

    state.merge!(lists.to_h) if user.list_is_renderable

    state
  end

  private

  def rt_params
    { :rt_params => PrivatePub.subscription(:channel => "/messages/#{current_user.id}") }
  end

  def auth
    {
      :auth => {
        :loggingin => false,
        :loginError => nil,
        :signedInFirstTime => ( current_user.sign_in_count.to_i < 2 ),
        :user => CurrentUserSerializer.new(current_user).as_json
      }
    }
  end

  def qr_code
    {
      :qrCode => {
        :imgString => QRCodeGenerator.new(current_user.uuid).generate.to_data_url
      }
    }
  end

  def notifications
    {
      :notifications => NotificationService.new(current_user).notifications
    }
  end

  def careteams_and_invites
    {
      :careteamInvitations => careteamInvites,
      :careteamRequests => careteamRequests,
      :careteams => serialize_collection(current_user.careteams, CareteamSerializer).as_json
    }
  end

  def careteam_and_its_data
    careteam = current_user.careteam
    return if careteam.nil?

    {
      :careteamWithMembers => CareteamWithMembersSerializer.new(careteam).as_json,
      :careteamInvitations => careteamInvites,
      :careteamRequests => careteamRequests
    }
  end

  def careteamInvites
    serialize_collection(current_user.send("received_requests").pending, RequestSerializer).as_json
  end

  def careteamRequests
    serialize_collection(current_user.send("sent_requests").pending, RequestSerializer).as_json
  end

  def lists
    {
      :lists => serialize_collection(List.all, ListSerializer)
    }
  end

  def appointment_preference
    {
      :appointmentPreference => AppointmentPreferenceSerializer.new(current_user.appointment_preference).as_json
    }
  end

  def surveys
    if current_user.admin? or current_user.study_admin?
      @survey = admin_survey_data
    elsif current_user.patient?
      @survey = patient_survey_data
    elsif current_user.physician?
      @survey = physician_survey_data
    else
      @survey = [].as_json
    end

    {
      :surveys => @survey.as_json
    }
  end

  def serialize_collection(collection, serializer)
    ActiveModel::ArraySerializer.new(collection, :each_serializer => serializer)
  end

  private

  def patient_survey_data
    survey_requests = current_user.received_surveys
    serialize_collection(survey_requests.first(10), UserSurveyFormSerializer).as_json
  end

  def physician_survey_data
    surveys = (
      current_user.surveys.includes(:creator) +
      Survey.created_by_admin.includes(:creator) +
      Survey.created_by_study_admin.includes(:creator)
    )
    serialize_collection(surveys.first(10), SurveyMinimalSerializer)
  end

  def admin_survey_data
    surveys = Survey.all.includes(:creator)
    serialize_collection(surveys.first(10), SurveyMinimalSerializer)
  end

end