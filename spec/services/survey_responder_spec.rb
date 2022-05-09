describe SurveyResponder do
  describe "#submit_response" do
    let!(:survey) { FactoryGirl.create(:survey) }
    let!(:patient) { FactoryGirl.create(:user) }
    let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let!(:user_survey_form) { FactoryGirl.create(:user_survey_form, :survey => survey, :sender => physician, :receiver => patient) }

    context "when the question is Descriptive Question" do
      let!(:descriptive_question) { FactoryGirl.create(:question, :survey => survey, :type => 'DescriptiveQuestion') }

      context "when the user attempts to submit the response" do
        let(:responses) do
          [
            {
              :question => descriptive_question,
              :response => "Response for the Descripttive question"
            }
          ]
        end

        it "should save the response for the question" do
          SurveyResponder.new(patient, responses, user_survey_form).submit_response
          expect(user_survey_form.descriptive_answers.last.description).to eq(responses[0][:response])
        end
      end

      context "when the response is blank for the descriptive_question" do
        let(:responses) do
          [
            {
              :question => descriptive_question,
              :response => ""
            }
          ]
        end

        it "should raise error" do
          expect do
            SurveyResponder.new(patient, responses, user_survey_form).submit_response
          end
          .to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Description can't be blank")
        end
      end
    end

    context "when the question is Multiple-Choice Question" do
      let!(:multiple_choice_question) { FactoryGirl.create(:question, :survey => survey, :type => 'MultipleChoiceQuestion') }
      let!(:choice1) { FactoryGirl.create(:choice, :question => multiple_choice_question) }
      let!(:choice2) { FactoryGirl.create(:choice, :question => multiple_choice_question) }

      context "when the user attempts to submit the response" do
        let(:responses) do
          [
            {
              :question => multiple_choice_question,
              :response => [ choice2.id ]
            }
          ]
        end

        it "should save the response for the question" do
          SurveyResponder.new(patient, responses, user_survey_form).submit_response
          expect(user_survey_form.multiple_choice_answers.last.choice_id).to eq(responses[0][:response][0])
        end
      end

      context "when no options are selected" do
        let(:responses) do
          [
            {
              :question => multiple_choice_question,
              :response => [ ]
            }
          ]
        end

        it "should raise error" do
          expect do
            SurveyResponder.new(patient, responses, user_survey_form).submit_response
          end
          .to raise_exception("Inputs are Invalid")
        end
      end
    end

    context "when the question is Range-Based Question" do
      let!(:range_based_question) { FactoryGirl.create(:question, :survey => survey, :type => 'RangeBasedQuestion', :min_range => 2, :max_range => 10) }

      context "when the user attempts to submit the response" do
        let(:responses) do
          [
            {
              :question => range_based_question,
              :response => 3
            }
          ]
        end

        it "should submit the response for the question" do
          SurveyResponder.new(patient, responses, user_survey_form).submit_response
          expect(user_survey_form.range_based_answers.last.value).to eq(responses[0][:response])
        end
      end

      context "when the user attempts to submit some invalid range" do
        let(:responses) do
          [
            {
              :question => range_based_question,
              :response => 50
            }
          ]
        end

        it "should submit the response for the question" do
          expect do
            SurveyResponder.new(patient, responses, user_survey_form).submit_response
          end
          .to raise_error(ActiveRecord::RecordNotSaved)
        end
      end

      context "when the user gives no response" do
        let(:responses) do
          [
            {
              :question => range_based_question,
              :response => nil
            }
          ]
        end

        it "should submit the response for the question" do
          expect do
            SurveyResponder.new(patient, responses, user_survey_form).submit_response
          end
          .to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Value can't be blank, Value is not a number")
        end
      end
    end

    context "when the question is List Based Question" do
      let!(:list) { FactoryGirl.create(:list) }
      let!(:option1) { FactoryGirl.create(:option, :list => list) }
      let!(:option2) { FactoryGirl.create(:option, :list => list) }
      let!(:option3) { FactoryGirl.create(:option, :list => list) }
      let!(:option4) { FactoryGirl.create(:option, :list => list) }

      context "when the question is of category 'multi_select'" do
        let!(:multi_select_question) { FactoryGirl.create(:question, :survey => survey, :type => 'ListDrivenQuestion', :list => list, :category => 'multi_select') }

        context "when the user attempts to submit the response with multiple options" do
          let(:responses) do
            [
              {
                :question => multi_select_question,
                :response => [ option2.id, option4.id ]
              }
            ]
          end

          it "should record all the options" do
            SurveyResponder.new(patient, responses, user_survey_form).submit_response
            response = multi_select_question.answers.last
            expect(response).to have_attributes(:question => multi_select_question, :creator => patient)
            expect(response.selected_options.map(&:option)).to include(option2.name, option4.name)
          end
        end

        context "when the user attempts to submit any option not included in the List" do
          let(:responses) do
            [
              {
                :question => multi_select_question,
                :response => [ 100 ]
              }
            ]
          end

          it "should raise error stating 'Inputs are Invalid'" do
            expect do
              SurveyResponder.new(patient, responses, user_survey_form).submit_response
            end
            .to raise_exception("Inputs are Invalid")
          end
        end
      end

      context "when the question is of the category 'single_select'" do
        let!(:single_select_question) { FactoryGirl.create(:question, :survey => survey, :type => 'ListDrivenQuestion', :list => list, :category => 1) }

        context "when the user attempts to give the response with single options" do
          let(:responses) do
            [
              {
                :question => single_select_question,
                :response => [ option2.id ]
              }
            ]
          end

          it "should record the option" do
            SurveyResponder.new(patient, responses, user_survey_form).submit_response
            response = single_select_question.answers.last
            expect(response).to have_attributes(:question => single_select_question, :creator => patient)
            expect(response.selected_options.map(&:option)).to include(option2.name)
          end
        end

        context "when the user attempts to give the response with multiple options" do
          let(:responses) do
            [
              {
                :question => single_select_question,
                :response => [ option2.id, option4.id ]
              }
            ]
          end

          it "should not save the record" do
            expect do
              SurveyResponder.new(patient, responses, user_survey_form).submit_response
            end
            .to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Only one option can be selected")
          end
        end
      end
    end
  end

end