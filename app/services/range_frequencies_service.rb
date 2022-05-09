# Service to compute frequencies for responses of Range Based questions
# Computes the data for individual patient, careteam patients and the global population
# Response produced by this Service is served to plot Distribution curve

class RangeFrequenciesService

  def initialize(question, user, patient)
    @question = question
    @user = user
    @patient = patient
    validate_parameters
    set_survey
    set_min_max_range
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

  # Returns array of patient ids of physician's careteams who answered the question
  def careteam_patients
    @user.associated_patients & completed_requests.map(&:receiver_id)
  end

  # Returns survey requests for the survey with submitted status
  def completed_requests
    @survey.user_survey_forms.where(:state => "submitted")
  end

  # Returns array of patient ids who answered the question
  def global_patients
    completed_requests.map(&:receiver_id)
  end

  # Array of range values provided as response by the Patient
  def answers_for_patient
    @question.answers.where("creator_id = ?", @patient.id).map(&:value)
  end

  # Array of range values provided as response by Patients of Physician's Careteam
  def answers_for_careteam_patients
    @question.answers.where("creator_id IN (?)", careteam_patients).map(&:value)
  end

  # Array of range values provided as response by any Patient
  def answers_for_global_patients
    @question.answers.where("creator_id IN (?)", global_patients).map(&:value)
  end

  # Initializes each range value with 0
  def ranges_with_initial_count
    Hash[ (@min..@max).to_a.map { |value| [value, 0] } ]
  end

  # Sets the minimum and maximum range for the question
  def set_min_max_range
    @min = @question.min_range rescue 0
    @max = @question.max_range rescue 0
  end

  # Sets the survey for the question
  def set_survey
    @survey = @question.survey
  end

  # Validates if the question category is correct
  def invalid_question_type_error
    return { :error => "Invalid question type" } unless @question.type == 'RangeBasedQuestion'
  end

  # Check if parameters passed are valid
  def validate_parameters
    raise 'Invalid parameters' unless ( @question.present? and @user.present? )
  end

  def get_response(answers)
    range_counts = ranges_with_initial_count
    answers.each do | answer |
      range_counts[answer.to_i] += 1 rescue nil
    end

    range_counts
  end

end

