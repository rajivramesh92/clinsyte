# Service to record the answers for the Survey given by the patients
# reviewer -> Patient object
# responses -> Array of objects containing question object and answer for that question
# request -> Survey Request object

class SurveyResponder

  def initialize(reviewer, responses = [], request)
    @reviewer = reviewer
    @responses = responses
    @request = request
    validate_parameters
  end

  # Method to record the responses
  # Use transactions for recording all or no response
  def submit_response
    @responses.each do |response|
      set_response_attributes(response)
      save_response_based_on_question_type
    end
  end

  def save_response_based_on_question_type
    if @question.descriptive?
      save_descriptive_answer
    elsif @question.multiple_choice?
      save_multiple_choice_answer
    elsif @question.range_based?
      save_range_based_answer
    elsif @question.list_driven?
      save_list_driven_answer
    end
  end

  private

  def save_descriptive_answer
    @request.descriptive_answers.create!(:question => @question,
    :description => @response, :creator => @reviewer)
  end

  def save_multiple_choice_answer # Can be Multi Selectable in future, so response is array of choice ids
    validate_choice
    @request.multiple_choice_answers.create!(:question => @question,
    :choice => @choice, :creator => @reviewer)
  end

  def save_range_based_answer
    @request.range_based_answers.create!(:question => @question,
    :value => @response.to_s, :creator => @reviewer)
  end

  def save_list_driven_answer
    @request.list_driven_answers.create!(:question => @question,
    :creator => @reviewer, :selected_options_attributes => get_option_list)
  end

  # Validates if options are apart of assosiated List for the Question
  # Formats them to be updated as nested attributes
  def get_option_list
    @response.map do | option |
      option = @question.options.find(option) rescue invalid_input
      {
        :option => option.name
      }
    end
  end

  # Validates if choice is a part of assosiaited choices for the Question
  def validate_choice
    @choice = @question.choices.find(@response.first.to_i) rescue invalid_input
  end

  # Checks if the parameters passed to the Service are present
  def validate_parameters
    invalid_input if @reviewer.nil? or @request.nil? or @responses.blank?
  end


  # Sets the question and response object from the parameters
  def set_response_attributes(response)
    @question = response[:question]
    @response = response[:response]
  end

  # Method to raise Invaid Input exception
  def invalid_input
    raise 'Inputs are Invalid'
  end

end