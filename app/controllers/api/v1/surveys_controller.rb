class Api::V1::SurveysController < Api::V1::BaseController

  include Concerns::SurveyParameterMapper

  load_resource :except => [ :create, :start, :submit ]
  authorize_resource

  before_filter :validate_patients, :only => [ :send_requests ]
  before_filter :validate_responses, :only => [ :submit ]
  before_filter :validate_questions, :only => [ :create ]
  before_filter :validate_if_editable, :only => [ :update ]

  # add pagination here
  def index
    if current_user.admin? or current_user.study_admin?
      surveys = Survey.all
    elsif current_user.physician?
      surveys = Survey.where(:creator => User.admin_and_study_admins.to_a.concat([current_user]))
    end
    surveys_after_search = SearchService.new(surveys, params[:search].try(:values)).search
    success_serializer_responder(paginate(surveys_after_search), SurveyMinimalSerializer)
  end

  def show
    success_serializer_responder(@survey, SurveySerializer)
  end

  # Endpoint to create a Survey with Questions
  def create
    survey = current_user.surveys.new(customized_survey_params)
    if survey.save
      success_serializer_responder(survey, SurveySerializer)
    else
      error_serializer_responder(survey)
    end
  end

  # Endpoint to update Survey Details
  def update
    if @survey.update(customized_survey_params)
      success_serializer_responder(@survey.reload, SurveySerializer)
    else
      error_serializer_responder(@survey)
    end
  end

  # Endpoint to destroy a Survey
  def destroy
    if @survey.inactive!
      success_serializer_responder('Survey removed successfully')
    else
      error_serializer_responder(@survey)
    end
  end

  # Endpoint to send Survey Requests to patients
  def send_requests
    patients = params[:patient_ids]
    SurveyRequestSender.new(current_user, patients, @survey).send
    success_serializer_responder('Survey requests sent successfully')
  end

  # Endpoint to start the Survey
  def start
    survey_request = current_user.received_surveys.find(params[:request_id]) rescue nil
    if survey_request && survey_request.start
      success_serializer_responder("Survey started successfully")
    else
      error_serializer_responder("Failed to start Survey")
    end
  end

  # Endpoint to submit Survey Responses
  def submit
    ActiveRecord::Base.transaction do
      submit_responses_and_change_state
    end
    success_serializer_responder(@survey_form, SurveyRequestSerializer)
  rescue
    error_serializer_responder('Response submission unsuccessful')
  end

  # Endpoint to return all the survey requests for the given survey
  # with pagination and filters
  def requests
    requests = current_user.sent_surveys.where(:survey => @survey).includes(:receiver)
    success_serializer_responder(filter_and_paginate(requests), UserSurveyFormSerializer)
  end

  private

  def survey_params
    params.require(:survey).permit(
      :id,
      :name,
      :treatment_plan_dependent,
      :questions_attributes => [
        :id,
        :description,
        :status,
        :category,
        :attrs => [ :option, :min, :max, :list_id, :category, :id ]
      ]
    )
  end

  def send_requests_params
    params.permit(:id, :patient_ids => [])
  end

  def submit_params
    params.permit(:id, :responses => [])
  end

  def submit_responses_and_change_state
    SurveyResponder.new(current_user, @responses, @survey_form).submit_response
    @survey_form.try('submit')
  end

  # Method to check if questions are present during Survey Creation
  def validate_questions
    unless params[:survey][:questions_attributes].present?
      error_serializer_responder("Questions needs to be added for creating Survey")
    end
  end

  # Method to check if a patient exists for every id passed as params
  def validate_patients
    unless params[:patient_ids].all? { |patient| User.find(patient).patient? rescue false }
      error_serializer_responder("Surveys can only be sent to patients")
    end
  end

  # Method to check response before Submitting
  def validate_responses
    @survey_form = current_user.received_surveys.find(params[:request_id]) rescue nil
    questions = params[:responses].map { |response| response["ques_id"].to_i } - @survey_form.survey.questions.map(&:id) rescue true
    if questions.blank?
      @responses = params[:responses].map { |response| { :question => Question.find(response['ques_id']), :response => response['response']} }
    else
      error_serializer_responder('Invalid Survey Response')
    end
  end

  def filter_and_paginate(requests)
    paginate(FilterService.new(requests, params[:filters].try(:values)).filter)
  end

  def validate_if_editable
    unless @survey.is_editable?
      error_serializer_responder("Survey can not be updated as it has existing responses")
    end
  end

end
