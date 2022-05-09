class Api::V1::SurveyConfigurationsController < Api::V1::BaseController

  authorize_resource
  before_filter :validate_survey, :only => [ :create ]
  before_filter :filter_patients_to_send_survey, :only => [ :create ]

  # Endpoint to return all the Independent Surveys scheduled for sending to the patients
  def index
    success_serializer_responder(current_user.survey_configurations, SurveyConfigurationSerializer)
  end

  # Endpoint to create an Independent Survey for patients
  def create
    begin
      @independent_survey = current_user.survey_configurations.create(survey_params)
      schedule_survey
      success_serializer_responder(@independent_survey, SurveyConfigurationSerializer)
    rescue
      error_serializer_responder(@independent_survey)
    end
  end

  # Enpoint to destroy an Independent Survey configuration
  def destroy
    survey_configuration = current_user.survey_configurations.find(params[:id]) rescue nil
    begin
      survey_configuration.destroy!
      success_serializer_responder("Survey Removed successfully")
    rescue
      error_serializer_responder("Survey Removal unsuccessfull")
    end
  end

  private

  def survey_params
    params.require(:survey_configuration).permit(:survey_id, :from_date, :days, :schedule_time)
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
      @independent_survey.receipients.create(:receiver_id => receiver)
    end
  end

end
