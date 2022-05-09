class Api::V1::EventDependentSurveysController < Api::V1::BaseController

  authorize_resource
  before_filter :validate_survey, :only => [ :create ]
  before_filter :filter_patients_to_send_survey, :only => [ :create ]

  # Endpoint to return all the Dependent Surveys scheduled for sending to the patients
  def index
    surveys = current_user.event_dependent_surveys
    success_serializer_responder(surveys, EventDependentSurveySerializer)
  end

  # Endpoint to create a Dependent Survey for patients
  def create
    begin
      @dependent_survey = current_user.event_dependent_surveys.create(survey_params)
      schedule_survey
      success_serializer_responder(@dependent_survey, EventDependentSurveySerializer)
    rescue
      error_serializer_responder(@dependent_survey)
    end
  end

  # Enpoint to destroy a Dependent Survey configuration
  def destroy
    survey = current_user.event_dependent_surveys.find(params[:id]) rescue nil
    begin
      survey.destroy
      success_serializer_responder('Survey Removed successfully')
    rescue
      error_serializer_responder('Survey removal unsuccessfull')
    end
  end

  private

  def survey_params
    params.permit( :survey_id, :time )
  end

  # Method to check if the survey is a valid survey or not
  def validate_survey
    survey = Survey.find(survey_params[:survey_id]) rescue nil
    error_serializer_responder("Invalid Survey for scheduling") unless survey.present?
  end

  # Method to filter the patients for sending the survey based on the filters sent as parameters
  def filter_patients_to_send_survey
    patient_collection = current_user.associated_patients rescue []
    @patients = SurveyFilter.new(patient_collection, params[:filters]).filter rescue patient_collection
  end

  # Method to add receipients for receiving the Surveys
  def schedule_survey
    @patients.each do | receiver |
      @dependent_survey.receipients.create(:receiver_id => receiver)
    end
  end
end
