class Api::V1::QuestionsController < Api::V1::BaseController

  before_filter :validate_question, :only => :statistic
  before_filter :validate_patient, :only => :statistic
  before_filter :validate_chart_type, :only => :statistic

  skip_before_filter :validate_patient, :if => lambda { params[:patient_id].blank? }

  def statistic
    if params['type'] == 'mcq_option_counts'
      response = McqOptionCountingService.new(*parameters).response_data
    elsif params['type'] == 'whiskers_chart_data'
      response = WhiskersChartService.new(*parameters).response_data
    elsif params['type'] == 'range_frequencies'
      response = RangeFrequenciesService.new(*parameters).response_data
    elsif params['type'] == 'list_option_counts'
      response = ListOptionCountingService.new(*parameters).response_data
    end

    render :json => response
  end

  private

  def validate_question
    @question = Question.find(params[:id].to_i) rescue nil
    error_serializer_responder("Question does not exists") unless @question.present?
  end

  def validate_patient
    @patient = User.find(params[:patient_id].to_i) rescue nil
    error_serializer_responder("Needs to be a patient") unless @patient.try("patient?")
  end

  def validate_chart_type
    valid_types = ['mcq_option_counts', 'whiskers_chart_data', 'range_frequencies', 'list_option_counts']
    error_serializer_responder("Invalid type field") unless valid_types.include?(params['type'])
  end

  def parameters
    [ @question, current_user, @patient ]
  end

end