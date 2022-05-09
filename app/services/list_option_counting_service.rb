# Service to compare survey results for individual patient, Physician's poplulation and Global Population
# Takes into consideration only List Driven Questions
# Response produced by this Service is served to Pie Chart and Bar Chart

class ListOptionCountingService

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

  def answers_for_patient
    @question.answers.where("creator_id = ?", @patient.id )
  end

  def answers_for_careteam_patients
    @question.answers.where("creator_id IN (?)", careteam_patients)
  end

  def answers_for_global_patients
    @question.answers.where("creator_id IN (?)", global_patients)
  end

  # Returns the hash with option name and their counts
  def get_option_counts(answers)
    SelectedOption.where(:list_driven_answer => answers).group_by(&:option)
  end

  # Method to count the options given in response
  def get_response(answers)
    option_groups = get_option_counts(answers)
    form_response(option_groups).sort_by { |h| h[:count] }.reverse
    # fr = form_response(option_groups).sort_by { |h| h[:count] }.reverse

    # if fr.length > 5
    #   top = fr.first(5)
    #   rest = fr.slice!(5..fr.length - 1)
    #   # others = form_response(rest)
    # end
  end

  # Method to form response objects
  def form_response(option_groups)
    option_groups.map do |option, group|
      {
        :option => option,
        :count => group.count
      }
    end
  end

  # Checks if the question is a Multiple Choice question
  def invalid_question_type_error
    return { :error => "Invalid question type" } unless @question.type == 'ListDrivenQuestion'
  end

  # Checks if the parameters are valid
  def validate_parameters
    raise "Invalid parameters" unless ( @question.present? and @user.present? )
  end

  # Sets the Survey for the question
  def set_survey
    @survey = @question.survey
  end

end
