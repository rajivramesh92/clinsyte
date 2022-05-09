describe Api::V1::SurveysController do

  describe '#index' do
    let(:physician) { FactoryGirl.create(:user_with_physician_role) }

    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        get :index

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context "when the user is logged in as a physician" do
      let!(:physician2) { FactoryGirl.create(:user_with_physician_role) }
      let!(:admin) { FactoryGirl.create(:user_with_admin_role) }
      let!(:survey1) { FactoryGirl.create(:survey, :creator => physician, :questions_attributes => [{:description => 'Question 1'}]) }
      let!(:survey2) { FactoryGirl.create(:survey, :creator => physician, :questions_attributes => [{:description => 'Question 2'}]) }
      let!(:survey3) { FactoryGirl.create(:survey, :creator => physician2, :questions_attributes => [{:description => 'Question 3'}]) }
      let!(:survey4) { FactoryGirl.create(:survey, :creator => admin, :questions_attributes => [{:description => 'Question 4'}]) }
      let!(:survey5) { FactoryGirl.create(:survey, :creator => admin, :questions_attributes => [{:description => 'Question 5'}]) }

      before do
        token_sign_in(physician)
      end

      context "when the user attempts to view the Surveys" do
        it "should return all the surveys created by him and admin" do
          get :index

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data'].map { |survey| survey['id'] }).to eq(Survey.where(:creator => User.admin_and_study_admins.to_a.concat([physician])).map(&:id))
        end
      end
    end

    context "when the user is logged in as an admin" do
      let!(:admin) { FactoryGirl.create(:user_with_admin_role) }
      let!(:survey1) { FactoryGirl.create(:survey, :creator => admin, :questions_attributes => [{:description => 'Question 1'}]) }
      let!(:survey2) { FactoryGirl.create(:survey, :creator => admin, :questions_attributes => [{:description => 'Question 2'}]) }
      let!(:survey3) { FactoryGirl.create(:survey, :creator => physician, :questions_attributes => [{:description => 'Question 3'}]) }

      before do
        token_sign_in(admin)
      end

      context "when the user attempts to view all his Surveys" do
        it "should return all the surveys" do
          get :index

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data'].map { |survey| survey['id'] }).to eq(Survey.all.map(&:id))
        end
      end
    end

    context "when support user with study admin privilege is logged in" do
      let!(:support) { FactoryGirl.create(:user_with_support_role) }
      let!(:survey1) { FactoryGirl.create(:survey, :creator => support, :questions_attributes => [{:description => 'Question 1'}]) }
      let!(:survey2) { FactoryGirl.create(:survey, :creator => support, :questions_attributes => [{:description => 'Question 2'}]) }
      let!(:survey3) { FactoryGirl.create(:survey, :creator => physician, :questions_attributes => [{:description => 'Question 3'}]) }

      before do
        token_sign_in(support)
      end

      context "when the user attempts to view all his Surveys" do
        before do
          support.study_admin!
        end

        it "should return all the surveys" do
          get :index

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data'].map { |survey| survey['id'] }).to eq(Survey.all.map(&:id))
        end
      end
    end

  end

  describe '#create' do
    let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let!(:list) { FactoryGirl.create(:list) }
    let!(:option1) { FactoryGirl.create(:option, :list => list) }
    let!(:option2) { FactoryGirl.create(:option, :list => list) }
    let!(:option3) { FactoryGirl.create(:option, :list => list) }

    let(:params) do
      {
        :survey => {
          :name => 'MySurvey',
          :treatment_plan_dependent => true,
          :questions_attributes => [
            {
              :description => "Question 1",
              :category => 'descriptive'
            },
            {
              :description => "Question 2",
              :category => 'range_based',
              :attrs => { :min => 2, :max => 5 }
            },
            {
              :description => "Question 3",
              :category => 'multiple_choice',
              :attrs => [ {:option => 'option 1'}, {:option => 'option 2'} ]
            },
            {
              :description => "Question 4",
              :category => 'list_driven',
              :attrs => { :list_id => list.id, :category => 'multi_select' }
            }
          ]
        }
      }
    end

    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        post :create, params

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context "when the user is logged in as a physician" do
      before do
        token_sign_in(physician)
      end

      context "when the user attempts to Create a Survey with Questions" do
        it "should Create the Survey with Questions" do
          post :create, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(physician.surveys.last.name).to eq(params[:survey][:name])
          expect(json['data']['questions'].map{ |ques| ques['id']}).to eq(physician.surveys.last.questions.map(&:id))
          expect(Question.find_by_description(params[:survey][:questions_attributes][1][:description])).to have_attributes(:min_range => 2, :max_range => 5)
          expect(Question.find_by_description(params[:survey][:questions_attributes][2][:description]).choices.map(&:option)).to match_array(params[:survey][:questions_attributes][2][:attrs].map { |option| option[:option] })
          expect(Question.find_by_description(params[:survey][:questions_attributes][3][:description]).options.map(&:name)).to match_array(List.find(params[:survey][:questions_attributes][3][:attrs][:list_id].to_i).options.map(&:name))
        end
      end
    end

    context "when the user is logged in as an admin" do
      let(:admin) { FactoryGirl.create(:user_with_admin_role) }

      before do
        token_sign_in(admin)
      end

      context "when the user attempts to Create a Survey with Questions" do
        it "should Create the Survey with Questions" do
          post :create, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(admin.surveys.last.name).to eq(params[:survey][:name])
          expect(json['data']['questions'].map{ |ques| ques['id']}).to eq(admin.surveys.last.questions.map(&:id))
          expect(Question.find_by_description(params[:survey][:questions_attributes][1][:description])).to have_attributes(:min_range => 2, :max_range => 5)
          expect(Question.find_by_description(params[:survey][:questions_attributes][2][:description]).choices.map(&:option)).to match_array(params[:survey][:questions_attributes][2][:attrs].map { |option| option[:option] })
          expect(Question.find_by_description(params[:survey][:questions_attributes][3][:description]).options.map(&:name)).to match_array(List.find(params[:survey][:questions_attributes][3][:attrs][:list_id].to_i).options.map(&:name))
        end
      end
    end

    context "when the user is logged in as an study admin" do
      let(:support) { FactoryGirl.create(:user_with_support_role) }

      before do
        token_sign_in(support)
      end

      context "when the user attempts to Create a Survey with Questions" do
        before do
          support.study_admin!
        end

        it "should Create the Survey with Questions" do
          post :create, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(support.surveys.last.name).to eq(params[:survey][:name])
          expect(json['data']['questions'].map{ |ques| ques['id']}).to eq(support.surveys.last.questions.map(&:id))
          expect(Question.find_by_description(params[:survey][:questions_attributes][1][:description])).to have_attributes(:min_range => 2, :max_range => 5)
          expect(Question.find_by_description(params[:survey][:questions_attributes][2][:description]).choices.map(&:option)).to match_array(params[:survey][:questions_attributes][2][:attrs].map { |option| option[:option] })
          expect(Question.find_by_description(params[:survey][:questions_attributes][3][:description]).options.map(&:name)).to match_array(List.find(params[:survey][:questions_attributes][3][:attrs][:list_id].to_i).options.map(&:name))
        end
      end
    end

    context "when the user is logged in as a patient" do
      let(:patient) { FactoryGirl.create(:user) }

      before do
        token_sign_in(patient)
      end

      context "when the user attempts to Create a Survey" do
        it "should not be able to create it" do
          post :create, :name => 'Survey1'

          expect_unauthorized_access
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to include('Unauthorized access')
        end
      end
    end
  end

  describe 'update' do
    let(:physician1) { FactoryGirl.create(:user_with_physician_role) }
    let(:physician2) { FactoryGirl.create(:user_with_physician_role) }
    let(:survey1) { physician1.surveys.create(:name => 'Survey1', :questions_attributes => [{:description => 'Question 1'}]) }
    let(:survey2) { physician2.surveys.create(:name => 'Survey2', :questions_attributes => [{:description => 'Question 2'}]) }
    let(:params) do
      {
        :id => survey1.id,
        :survey => {
          :id => survey1.id,
          :name => survey1.name,
          :questions_attributes => [
            {
              :id => survey1.questions.last.id,
              :description => "Demo Question 1",
              :status => 'active'
            },
            {
              :description => "Demo Question 2",
              :status => 'active'
            }
          ]
        }
      }
    end

    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        patch :update, params

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context "when the user is logged in" do
      context "as a physician" do
        before do
          token_sign_in(physician1)
        end

        context "when the user attempts to Update a Survey created by him" do
          it "should be able to update it" do
            patch :update, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(physician1.surveys.last.name).to eq(params[:survey][:name])
            expect(json['data']['questions'].map{ |ques| ques['description']}).to eq(physician1.surveys.last.questions.map(&:description))
          end
        end

        context "when the user attempts to Destroy a question for a survey" do
          before do
            params[:survey][:questions_attributes][0][:status] = 'inactive'
          end

          it "should be able to destroy it" do
            patch :update, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(physician1.surveys.last.questions.active.map{ |ques| ques.description }).not_to include(params[:survey][:questions_attributes][0][:description])
          end
        end

        context "when the user attempts to Update a Survey not created by him" do
          before do
            params[:id] = survey2.id
          end

          it "should not be able to update it" do
            patch :update, params

            expect_unauthorized_access
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Unauthorized access')
          end
        end

      end

      context "as admin" do
        let(:admin) { FactoryGirl.create(:user_with_admin_role) }
        before do
          token_sign_in(admin)
        end

        context "when the user attempts to Update a Survey" do
          it "should be able to update it" do
            patch :update, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(physician1.surveys.last.name).to eq(params[:survey][:name])
            expect(json['data']['questions'].map{ |ques| ques['description']}).to eq(physician1.surveys.last.questions.map(&:description))
          end
        end
      end

      context "as study admin" do
        let(:support) { FactoryGirl.create(:user_with_support_role) }
        before do
          token_sign_in(support)
          support.study_admin!
        end

        context "when the user attempts to Update a Survey" do
          it "should be able to update it" do
            patch :update, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(physician1.surveys.last.name).to eq(params[:survey][:name])
            expect(json['data']['questions'].map{ |ques| ques['description']}).to eq(physician1.surveys.last.questions.map(&:description))
          end
        end
      end
    end
  end

  describe '#destroy' do
    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        delete :destroy, :id => 1

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context "when the user is logged in" do
      context "as physician" do
        let(:physician) { FactoryGirl.create(:user_with_physician_role) }
        before do
          token_sign_in(physician)
        end

        context "when the user attempts to Destroy a Survey" do
          let!(:survey) { FactoryGirl.create(:survey, :creator => physician) }
          let!(:question1) { FactoryGirl.create(:question, :survey => survey) }

          it "should make the survey inactive without deleting the questions related to it" do
            delete :destroy, :id => survey.id

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']).to include('Survey removed successfully')
            expect(physician.reload.surveys).not_to include(survey)
            expect(survey.questions).to include(question1)
          end
        end

        context "when the user attempts to destroy a survey not created by him" do
          let!(:survey1) { FactoryGirl.create(:survey) }

          it "should not delete the survey" do
            delete :destroy, :id => survey1.id

            expect_unauthorized_access
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Unauthorized access')
          end
        end
      end

      context "as admin" do
        let(:admin) { FactoryGirl.create(:user_with_admin_role) }
        before do
          token_sign_in(admin)
        end

        context "when the user attempts to destroy a survey" do
          let!(:survey) { FactoryGirl.create(:survey) }

          it "should return error stating 'Unauthorized access'" do
            delete :destroy, :id => survey.id

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']).to include('Survey removed successfully')
            expect(admin.reload.surveys).not_to include(survey)
          end
        end
      end

      context "as study admin" do
        let(:support) { FactoryGirl.create(:user_with_support_role) }
        before do
          token_sign_in(support)
          support.study_admin!
        end

        context "when the user attempts to destroy a survey" do
          let!(:survey) { FactoryGirl.create(:survey) }

          it "should return error stating 'Unauthorized access'" do
            delete :destroy, :id => survey.id

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']).to include('Survey removed successfully')
            expect(support.reload.surveys).not_to include(survey)
          end
        end
      end

      context "as patient" do
        let(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        context "when the user attempts to destroy a survey" do
          let!(:survey) { FactoryGirl.create(:survey) }

          it "should return error stating 'Unauthorized access'" do
            delete :destroy, :id => survey.id

            expect_unauthorized_access
            expect_json_content
            expect(json['errors']).to include("Unauthorized access")
          end
        end
      end
    end
  end

  describe "#send_requests" do
    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        post :send_requests, :id => 2

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context "when the user is logged in as a physician" do
      let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let!(:survey1) { physician.surveys.create(:name => 'Survey1', :questions_attributes => [{:description => 'Question 1'}]) }
      let!(:survey2) { physician.surveys.create(:name => 'Survey2', :questions_attributes => [{:description => 'Question 2'}]) }
      let!(:patient1) { FactoryGirl.create(:user) }
      let!(:patient2) { FactoryGirl.create(:user) }
      let(:params) do
        {
          :id => survey1.id,
          :patient_ids => [patient1.id ,patient2.id]
        }
      end
      before do
        token_sign_in(physician)
      end

      context "when the user attempts to send a survey to some patients" do
        it "should send the survey to all the patients and create notification accordingly" do
          post :send_requests, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data']).to include('Survey requests sent successfully')
          expect(physician.sent_surveys.map(&:receiver_id)).to include(patient1.id, patient2.id)
          expect(physician.sent_notifications.map(&:recipient_id)).to include(patient1.id, patient2.id)
        end
      end

      context "when the ids passed as params does not belongs to patients" do
        before do
          params[:patient_ids] << physician.id
        end
        it "should raise error stating 'Surveys can only be sent to patients'" do
          post :send_requests, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to include('Surveys can only be sent to patients')
        end
      end

      context "when the survey passed does not exists" do
        before do
          params[:id] = 100000
        end
        it "should raise error stating 'Surveys can only be sent to patients'" do
          post :send_requests, params

          expect_not_found_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to include('No such record')
        end
      end

      context "when the survey passed is deleted by the physician" do
        before do
          survey1.inactive!
          params[:id] << survey1.id
        end
        it "should raise error stating 'Surveys can only be sent to patients'" do
          post :send_requests, params

          expect_not_found_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to include('No such record')
        end
      end
    end
  end

  describe '#submit' do
    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        post :submit, :id => 1

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context 'when the user is logged in' do
      let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let!(:patient) { FactoryGirl.create(:user) }

      let!(:survey) { FactoryGirl.create(:survey) }
      let!(:question1) { FactoryGirl.create(:question, :survey => survey, :type => 'DescriptiveQuestion') }
      let!(:question2) { FactoryGirl.create(:question, :survey => survey, :type => 'MultipleChoiceQuestion') }
      let!(:choice1) { FactoryGirl.create(:choice, :question => question2) }
      let!(:choice2) { FactoryGirl.create(:choice, :question => question2) }
      let!(:question3) { FactoryGirl.create(:question, :survey => survey, :type => 'RangeBasedQuestion', :min_range => 2, :max_range => 10) }
      let!(:list) { FactoryGirl.create(:list) }
      let!(:option1) { FactoryGirl.create(:option, :list => list) }
      let!(:option2) { FactoryGirl.create(:option, :list => list) }
      let!(:option3) { FactoryGirl.create(:option, :list => list) }
      let!(:option4) { FactoryGirl.create(:option, :list => list) }
      let!(:question4) { FactoryGirl.create(:question, :survey => survey, :type => 'ListDrivenQuestion', :list => list, :category => 0) }

      let!(:survey_request) { FactoryGirl.create(:user_survey_form, :survey => survey, :sender => physician, :receiver => patient) }
      let(:params) do
        {
          :id => survey.id,
          :request_id => survey_request.id,
          :responses => [
            {
              :ques_id => question1.id,
              :response => "Answer to question 1"
            },
            {
              :ques_id => question2.id,
              :response => [ choice2.id ]
            },
            {
              :ques_id => question3.id,
              :response => 3
            },
            {
              :ques_id => question4.id,
              :response => [ option2.id, option4.id ]
            }
          ]
        }
      end

      context "as a physician" do
        before do
          token_sign_in(physician)
        end

        context "when the user attempts to submit the survey responses" do
          before do
            survey_request.start
          end
          it "should return error 'Unauthorized access'" do
            post :submit, params

            expect_unauthorized_access
            expect_json_content
            expect(json['errors']).to include("Unauthorized access")
          end
        end
      end

      context "as a patient" do
        before do
          token_sign_in(patient)
          survey_request.start
        end

        context "when the user attempts to submit the survey responses" do
          it "should submit the responses successfully" do
            post :submit, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')

            submitted_responses = params[:responses]
            expect(survey_request.answers).to be_any { |answer| answer.try("description").eql?(submitted_responses[0][:response]) }
            expect(survey_request.multiple_choice_answers.last.choice.option).to eq(Choice.find(submitted_responses[1][:response][0]).option)
            expect(survey_request.answers).to be_any { |answer| answer.try("value").eql?(submitted_responses[2][:response]) }
            expect(survey_request.list_driven_answers.last.selected_options.map(&:option)).to include(option2.name, option4.name)
          end
        end

        context "when the user attempts to submit the survey for a second survey request" do
          let(:survey_request2) { FactoryGirl.create(:user_survey_form, :survey => survey, :sender => physician, :receiver => patient) }
          before do
            post :submit, params

            survey_request2.start
            params[:request_id] = survey_request2.id
          end

          it "should submit the responses successfully" do
            post :submit, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')

            submitted_responses = params[:responses]
            expect(survey_request.answers).to be_any { |answer| answer.try("description").eql?(submitted_responses[0][:response]) }
            expect(survey_request.multiple_choice_answers.last.choice.option).to eq(Choice.find(submitted_responses[1][:response][0]).option)
            expect(survey_request.answers).to be_any { |answer| answer.try("value").eql?(submitted_responses[2][:response]) }
            expect(survey_request.list_driven_answers.last.selected_options.map(&:option)).to include(option2.name, option4.name)
          end
        end

        context "when the user attempts to submit a survey not sent to him" do
          before do
            params[:request_id] = 100
          end
          it "should raise error stating ' Response'" do
            post :submit, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Invalid Survey Response')
          end
        end

        context "when the questions being submitted does not belong to the survey" do
          let!(:survey2) { FactoryGirl.create(:survey, :creator => physician) }
          let!(:question3) { FactoryGirl.create(:question, :survey => survey2) }
          before do
            params[:responses] <<  {
              :ques_id => question3.id,
              :description => 'answer to question 3'
            }
          end
          it "should raise error 'Invalid survey Response'" do
            post :submit, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Invalid Survey Response')
          end
        end

      end
    end
  end

  describe '#start' do
    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        post :start, :id => 1

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context "when the user is logged in" do
      context "as physician" do
        let(:physician) { FactoryGirl.create(:user_with_physician_role) }
        before do
          token_sign_in(physician)
        end

        it "should return error 'Authorized users only'" do
          post :start, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as admin" do
        let(:admin) { FactoryGirl.create(:user_with_admin_role) }
        before do
          token_sign_in(admin)
        end
        it "should return error 'Authorized users only'" do
          post :start, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as a patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        context "when the user attempts to start the survey" do
          let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
          let!(:survey_request) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient) }
          let(:params) do
            {
              :id => survey_request.survey.id,
              :request_id => survey_request.id
            }
          end

          context "with invalid survey id as paramater" do
            before do
              params[:request_id] = -1
            end
            it "should raise error stating 'Survey not found'" do
              post :start, params

              expect_success_status
              expect_json_content
              expect(json['status']).to eq('error')
              expect(json['errors']).to include('Failed to start Survey')
            end
          end

          context "when survey request has not been sent for the survey" do
            let(:survey) { FactoryGirl.create(:survey) }
            it "should raise error stating 'Failed to start survey'" do
              post :start, :id => survey.id

              expect_success_status
              expect_json_content
              expect(json['status']).to eq('error')
              expect(json['errors']).to include('Failed to start Survey')
            end
          end

          context "when survey has already been submitted" do
            before do
              survey_request.start
              survey_request.submit
            end
            it "should raise error stating 'Failed to start survey'" do
              post :start, params

              expect_success_status
              expect_json_content
              expect(json['status']).to eq('error')
              expect(json['errors']).to include('Failed to start Survey')
            end
          end

          context "when survey has not been responded" do
            it "should start the survey successfully" do
              post :start, params

              expect_success_status
              expect_json_content
              expect(json['status']).to eq('success')
              expect(json['data']).to include('Survey started successfully')
            end
          end

        end
      end
    end
  end

  describe "#requests" do
    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        get :requests, :id => 1

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context "when the user is logged in" do
      context "as patient" do
        let(:patient) { FactoryGirl.create(:user) }
        let!(:survey) { FactoryGirl.create(:survey) }
        before do
          token_sign_in(patient)
        end

        it "should return error 'Authorized users only'" do
          get :requests, :id => survey.id

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as admin" do
        let(:admin) { FactoryGirl.create(:user_with_admin_role) }
        let!(:survey) { FactoryGirl.create(:survey) }
        before do
          token_sign_in(admin)
        end
        it "should return error 'Authorized users only'" do
          get :requests, :id => survey.id

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as a physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        let!(:survey) { FactoryGirl.create(:survey, :creator => physician) }
        before do
          token_sign_in(physician)
        end

        context "when the user attempts to view all the requests for a survey" do
          let!(:patient1) { FactoryGirl.create(:user) }
          let!(:patient2) { FactoryGirl.create(:user) }
          let!(:patient3) { FactoryGirl.create(:user) }

          let!(:survey_request1) { FactoryGirl.create(:user_survey_form, :sender => physician, :survey => survey, :receiver => patient1) }
          let!(:survey_request2) { FactoryGirl.create(:user_survey_form, :sender => physician, :survey => survey, :receiver => patient2) }
          let!(:survey_request3) { FactoryGirl.create(:user_survey_form, :sender => physician, :survey => survey, :receiver => patient3) }
          let!(:survey_request4) { FactoryGirl.create(:user_survey_form, :sender => physician, :survey => survey, :receiver => patient2) }

          let(:params) do
            {
              :id => survey.id,
              :page => nil,
              :count => nil,
              :filters => { "0" => {"key" => 'receiver_id', "value" => patient2.id} }
            }
          end

          it "should return the results filtered as per the params with pagination" do
            get :requests, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')

            response = json["data"]
            expect(response.map { |survey_form| survey_form["receiver"]["id"] }.uniq).to match_array( [patient2.id] )
            expect(response.count).to eq(2)
          end
        end

        context "when the user attempts to view the requests with no filter or pagination params" do
          let!(:survey_request) { FactoryGirl.create_list(:user_survey_form, 30, :sender => physician, :survey => survey) }
          let(:params) do
            {
              :id => survey.id
            }
          end

          it "should return recent 10 (last) requests" do
            get :requests, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')

            response = json["data"]
            expect(response.count).to eq(10) # default count per page
            expect(response.map { |survey_form| survey_form["id"] }).to match_array(UserSurveyForm.first(10).map &:id) # recent 10 survey requests
          end
        end
      end
    end
  end

end