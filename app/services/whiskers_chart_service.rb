# Service to compare survey results for individual patients, Physician's poplulation and Global Population
# Takes into consideration only Range Based Questions
# Response produced by this Service is served to Whiskers Chart

class WhiskersChartService

  def initialize(question, user, patient)
    @question = question
    @user = user
    @patient = patient
    validate_parameters
    set_survey
  end

  def response_data
    return invalid_question_type_error if invalid_question_type_error

    if @patient.present?
      {
       :patient_response => get_response(answers_for_patient),
       :careteam_response => get_response(answers_for_careteam_patients),
       :global_response => get_response(answers_for_global_patients)
      }
    elsif @user.physician?
      {
       :careteam_response => get_response(answers_for_careteam_patients),
       :global_response => get_response(answers_for_global_patients)
      }
    elsif @user.admin? or @user.study_admin?
      {
        :global_response => get_response(answers_for_global_patients)
      }
    end
  end

  private

  # Method to calculate the medain for the values in the array
  def median(array)
    sorted = array.sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0 rescue 0
  end

  # Returns array of patient ids of physician's careteams who answered the question
  def careteam_patients
    @user.associated_patients & completed_requests.map(&:receiver_id)
  end

  # Returns array of patient ids who answered the question
  def global_patients
    completed_requests.map(&:receiver_id)
  end

  # Returns survey requests for the survey with submitted status
  def completed_requests
    @survey.user_survey_forms.where(:state => "submitted")
  end

  # Array of values provided as response by Patient
  def answers_for_patient
    @question.answers.where("creator_id = ?", @patient.id).map(&:value)
  end

  # Array of values provided as reponse by Patients of Physician's Careteam
  def answers_for_careteam_patients
    @question.answers.where("creator_id IN (?)", careteam_patients).map(&:value)
  end

  # Array of values provided as response by any Patient
  def answers_for_global_patients
    @question.answers.where("creator_id IN (?)", global_patients).map(&:value)
  end

  def get_response(array)
    return minimum_record_error(array) if minimum_record_error(array).present?

    first_quartile_array = get_first_quartile_array(array)
    second_quartile_array = get_second_quartile_array(array)

    form_response(array, first_quartile_array, second_quartile_array)
  end

  def form_response(array, first_quartile_array, second_quartile_array)
    {
      :min => array.min || 0,
      :max => array.max || 0,
      :median => median(array),
      :first_quartile => median(first_quartile_array),
      :third_quartile => median(second_quartile_array)
    }
  end

  # Returns the array for computation of First Quartile
  def get_first_quartile_array(array)
    array.sort.slice( 0, array.size/2 )
  end

  # Returns the array for computation of Second Quartile
  def get_second_quartile_array(array)
    array_len = array.size
    if array_len % 2 == 0
      array.sort.slice(array_len / 2, array_len / 2)
    else
      no_of_element = array_len == 1 ? 1 : array_len / 2
      array.sort.slice((array_len / 2) + 1, no_of_element)
    end
  end

  def invalid_question_type_error
    return { :error => "Invalid question type" } unless @question.type == 'RangeBasedQuestion'
  end

  def validate_parameters
    raise "Invalid parameters" unless ( @question.present? and @user.present? )
  end

  def minimum_record_error(data)
    return { :error => "Insufficient data to plot Whiskers graph" } unless data.size > 3
  end

  def set_survey
    @survey = @question.survey
  end

end