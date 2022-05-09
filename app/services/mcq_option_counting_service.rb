# Service to compare survey results for individual patient, Physician's poplulation and Global Population
# Takes into consideration only Multiple Choice Questions
# Response produced by this Service is served to Pie Chart and Bar Chart

class McqOptionCountingService

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

  # Returns the hash with option id as key and initial count as 0
  def options_with_initial_count
    Hash[ @question.choices.map(&:id).map { |choice| [choice, 0] } ]
  end

  def answers_for_patient
    @question.answers.where("creator_id = ?", @patient.id )
  end

  def answers_for_careteam_patients
    @question.answers.where("creator_id IN (?)", careteam_patients)
  end

  def answers_for_global_patients
    @question.answers.where("creator_id IN (?)", global_patients)
  end

  # Method to count the options given in response
  def get_response(answers)
    option_counts = options_with_initial_count
    answers.each do | answer |
      option_counts[answer.choice_id] += 1
    end

    form_response(option_counts)
  end

  # Method to form response objects
  def form_response(counts)
    counts.map do |option_id, count|
      {
        :option => Choice.find(option_id),
        :count => count
      }
    end
  end

  # Checks if the question is a Multiple Choice question
  def invalid_question_type_error
    return { :error => "Invalid question type" } unless @question.type == 'MultipleChoiceQuestion'
  end

  def validate_parameters
    raise 'Invalid parameters' unless ( @question.present? and @user.present? )
  end

  # Sets the Survey for the question
  def set_survey
    @survey = @question.survey
  end

end
