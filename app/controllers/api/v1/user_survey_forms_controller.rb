class Api::V1::UserSurveyFormsController < Api::V1::BaseController

  authorize_resource
  before_filter :validate_request, :only => :show
  before_filter :set_patient, :only => [ :remove_requests ], if: -> { current_user.physician? }

  def show
    success_serializer_responder(@survey_request, SurveyRequestSerializer)
  end

  def requests
    requests = current_user.received_surveys
    success_serializer_responder(filter_and_paginate(requests), UserSurveyFormSerializer)
  end

  def remove_requests
    begin
      requests = get_requests_to_remove
      requests.destroy_all
      success_serializer_responder("Survey Requests removed successfully")
    rescue
      error_serializer_responder("Survey requests can not be removed")
    end
  end

  private

  def validate_request
    begin
      @survey_request = current_user.received_surveys.find(params[:id]) if current_user.patient?
      @survey_request = current_user.sent_surveys.find(params[:id]) if current_user.physician?
    rescue
      error_serializer_responder("Invalid Survey Request")
    end
  end

  def filter_and_paginate(requests)
    paginate(FilterService.new(requests, params[:filters].try(:values)).filter)
  end

  def get_requests_to_remove
    current_user.patient? ? current_user.pending_tpd_surveys : current_user.pending_tpd_surveys.where(:receiver => @patient)
  end

  def set_patient
    @patient = User.find(params[:patient_id]) rescue nil
    error_serializer_responder("Patient does not exists") if @patient.nil?
  end

end
