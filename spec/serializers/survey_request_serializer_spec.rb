describe SurveyRequestSerializer do

  context "when an object is displayed using SurveyRequestSerializer" do
    let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let!(:patient) { FactoryGirl.create(:user) }
    let!(:survey) { FactoryGirl.create(:survey, :creator => physician) }
    let!(:question1) { FactoryGirl.create(:question, :survey => survey, :type => "DescriptiveQuestion") }
    let!(:question2) { FactoryGirl.create(:question, :survey => survey, :type => "MultipleChoiceQuestion") }
    let!(:choice1) { FactoryGirl.create(:choice, :question => question2) }
    let!(:choice2) { FactoryGirl.create(:choice, :question => question2) }
    let!(:choice3) { FactoryGirl.create(:choice, :question => question2) }
    let!(:question3) { FactoryGirl.create(:question, :survey => survey, :type => "RangeBasedQuestion", :min_range => 2, :max_range => 10) }
    let!(:list) { FactoryGirl.create(:list) }
    let!(:question4) { FactoryGirl.create(:question, :survey => survey, :type => "ListDrivenQuestion", :list => list) }
    let!(:option1) { FactoryGirl.create(:option, :list => list) }
    let!(:option2) { FactoryGirl.create(:option, :list => list) }
    let!(:option3) { FactoryGirl.create(:option, :list => list) }

    let!(:survey_request) { FactoryGirl.create(:user_survey_form, :survey => survey, :sender => physician, :receiver => patient, :state => "submitted") }

    let!(:answer1) { survey_request.descriptive_answers.create(:question => question1, :creator => patient, :description => 'Demo Answer') }
    let!(:answer2) { survey_request.multiple_choice_answers.create(:question => question2, :creator => patient, :choice_id => choice2.id) }
    let!(:answer3) { survey_request.range_based_answers.create(:question => question3, :creator => patient, :value => 5) }
    let!(:answer4) { survey_request.list_driven_answers.create(:question => question4, :creator => patient, :selected_options_attributes => [{:option => option3.name}, {:option => option1.name}]) }

    it "should display the object with the attributes defined in the SurveyRequestSerializer" do
      expect(SurveyRequestSerializer.new(survey_request).as_json).to include(
        {
          :id => survey_request.id,
          :state => survey_request.state,
          :sender => UserMinimalSerializer.new(survey_request.sender).as_json,
          :receiver => UserMinimalSerializer.new(survey_request.receiver).as_json,
          :sent_at => nil,
          :submitted_at => nil,
          :started_at =>  nil,
          :survey => {
            :id => survey.id,
            :name => survey.name,
            :attributes => [
              {
                :question => {
                  :id => question1.id,
                  :description => question1.description,
                  :category => "descriptive",
                  :attrs => []
                  },
                :response => answer1.description
              },
              {
                :question=>
                  {
                    :id => question2.id,
                    :description => question2.description,
                    :category => "multiple_choice",
                    :attrs => [
                      {
                        :id => choice1.id,
                        :option => choice1.option
                      },
                      {
                        :id => choice2.id,
                        :option => choice2.option
                      },
                      {
                        :id => choice3.id,
                        :option => choice3.option
                      }
                    ]
                  },
                :response => {
                  :id => answer2.choice.id,
                  :option => answer2.choice.option,
                }
              },
              {
                :question =>
                  {
                    :id => question3.id,
                    :description => question3.description,
                    :category => "range_based",
                    :attrs => {
                      :min => question3.min_range,
                      :max => question3.max_range
                    }
                  },
                :response => answer3.value
              },
              {
                :question =>
                  {
                    :id => question4.id,
                    :description => question4.description,
                    :category => "list_driven",
                    :attrs => {
                      :list => {
                        :id => list.id,
                        :name => list.name,
                        :options => [
                          {
                            :id => option1.id,
                            :option => option1.name
                          },
                          {
                            :id => option2.id,
                            :option => option2.name
                          },
                          {
                            :id => option3.id,
                            :option => option3.name
                          }
                        ]
                      },
                      :category => nil
                    }
                  },
                :response => [option3.name, option1.name]
              }
            ]
          }
        }
      )
    end
  end

end