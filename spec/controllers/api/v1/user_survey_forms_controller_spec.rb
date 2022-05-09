describe Api::V1::UserSurveyFormsController do

  describe '#show' do
    context "when the user is not logged in" do
      context "when the user attempts to access the request" do

        it "should give user unauthorized error" do
          get :show, :id => 1

          expect_json_content
          expect_unauthorized_access
          expect(json["errors"]).to be_present
          expect(json["errors"]).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "as physician" do
        let(:physician) { FactoryGirl.create(:user_with_physician_role) }
        before do
          token_sign_in(physician)
        end

        context "when the user attempts to access the survey request" do
          let(:patient1) { FactoryGirl.create(:user) }
          let(:patient2) { FactoryGirl.create(:user) }
          let!(:survey) { FactoryGirl.create(:survey, :creator => physician) }
          let!(:question1) { FactoryGirl.create(:question, :survey => survey) }
          let(:survey_request1) { FactoryGirl.create(:user_survey_form, :survey => survey, :sender => physician, :receiver => patient1) }
          let(:survey_request2) { FactoryGirl.create(:user_survey_form, :survey => survey, :sender => physician, :receiver => patient2) }

          context "when the response has not been generated" do
            it "should return the Survey request with questions" do
              get :show, :id => survey_request1.id

              expect_json_content
              expect_success_status
              expect(json["status"]).to eq('success')
              expect(json["data"]).to include({
                "id" => survey_request1.id,
                "state" => survey_request1.state,
                "receiver" => UserMinimalSerializer.new(patient1).as_json.stringify_keys,
                "sender" => UserMinimalSerializer.new(physician).as_json.stringify_keys,
                "started_at" => survey_request1.started_at,
                "submitted_at" => survey_request1.submitted_at,
                "survey" => {
                  "id" => survey.id,
                  "name" => survey.name,
                  "editable" => survey.is_editable?,
                  "treatment_plan_dependent" => survey.treatment_plan_dependent,
                  "questions"=> [
                    {
                      "id" => survey.questions.first.id,
                      "description" => survey.questions.first.description,
                      "category" => "descriptive",
                      "attrs" => []
                    }]
                  }
                })
            end
          end
        end
      end
    end
  end

  describe "#requests" do
    context "when the user is not logged in" do
      context "when the user attempts to access the request" do

        it "should give user unauthorized error" do
          get :requests, :id => 1

          expect_json_content
          expect_unauthorized_access
          expect(json["errors"]).to be_present
          expect(json["errors"]).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "as physician" do
        let(:physician) { FactoryGirl.create(:user_with_physician_role) }
        let(:survey) { FactoryGirl.create(:survey, :creator => physician) }
        before do
          token_sign_in(physician)
        end

        context "when the user attempts to access the survey request" do
          let!(:user_survey_form)  { FactoryGirl.create(:user_survey_form, :survey => survey, :sender => physician) }

          it "should return 'Unauthorized access'" do
            get :requests

            expect_json_content
            expect_unauthorized_access
            expect(json["errors"]).to be_present
            expect(json["errors"]).to include("Unauthorized access")
          end
        end
      end

      context "as patient" do
        let!(:patient1) { FactoryGirl.create(:user) }
        let!(:patient2) { FactoryGirl.create(:user) }
        let!(:patient3) { FactoryGirl.create(:user) }
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        let(:survey) { FactoryGirl.create(:survey, :creator => physician) }
        before do
          token_sign_in(patient1)
        end

        context "when the user attempts to access received survey requests without any filter pr pagination params" do
          let!(:request_set1) { FactoryGirl.create_list(:user_survey_form, 5, :survey => survey, :sender => physician, :receiver => patient1 ) }
          let!(:request_set2) { FactoryGirl.create_list(:user_survey_form, 5, :survey => survey, :sender => physician, :receiver => patient2 ) }
          let!(:request_set3) { FactoryGirl.create_list(:user_survey_form, 5, :survey => survey, :sender => physician, :receiver => patient3 ) }

          it "should return recent 10 requests" do
            get :requests

            expect_json_content
            expect_success_status
            expect(json["status"]).to eq('success')

            response = json["data"]
            expect(response.map { |survey_form| survey_form["receiver"]["id"] }.uniq).to match_array([patient1.id])
          end
        end
      end

    end
  end

  describe 'remove_requests' do
    context "when the user is not logged in" do
      context "when the user attempts to access the request" do

        it "should give user unauthorized error" do
          post :remove_requests

          expect_json_content
          expect_unauthorized_access
          expect(json["errors"]).to be_present
          expect(json["errors"]).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let(:patient) { FactoryGirl.create(:user) }
      let!(:physician1) { FactoryGirl.create(:user_with_physician_role) }
      let!(:patient1) { FactoryGirl.create(:user) }

      let!(:normal_survey1) { FactoryGirl.create(:survey, :creator => physician) }
      let!(:normal_survey2) { FactoryGirl.create(:survey, :creator => physician) }
      let!(:tpd_survey1) { FactoryGirl.create(:survey, :creator => physician, :treatment_plan_dependent => true) }
      let!(:tpd_survey2) { FactoryGirl.create(:survey, :creator => physician, :treatment_plan_dependent => true) }
      let!(:tpd_survey3) { FactoryGirl.create(:survey, :creator => physician, :treatment_plan_dependent => true) }

      let!(:request1)  { FactoryGirl.create(:user_survey_form, :survey => normal_survey1, :sender => physician1, :receiver => patient1) }
      let!(:request2)  { FactoryGirl.create(:user_survey_form, :survey => normal_survey2, :sender => physician) }
      let!(:request3)  { FactoryGirl.create(:user_survey_form, :survey => tpd_survey1, :sender => physician1) }
      let!(:request4)  { FactoryGirl.create(:user_survey_form, :survey => tpd_survey2, :sender => physician, :receiver => patient1) }
      let!(:request5)  { FactoryGirl.create(:user_survey_form, :survey => tpd_survey3, :sender => physician1, :receiver => patient1) }

      context "as physician" do
        before do
          token_sign_in(physician)
        end

        context "when the user attempts to remove all his sent tpd survey requests" do
          it "should remove only his pending or started tpd requests" do
            sent_survey_request_ids_by_physician = physician.sent_surveys.where(:receiver => patient1).tpd.pending.map(&:id)
            post :remove_requests, :patient_id => patient1.id

            expect_json_content
            expect_success_status
            expect(json["status"]).to eq('success')
            expect(sent_survey_request_ids_by_physician - UserSurveyForm.all.map(&:id)).to match_array(sent_survey_request_ids_by_physician)
          end
        end
      end

      context "as patient" do
        before do
          token_sign_in(patient)
        end

        context "when the user attempts to remove all his received tpd survey requests" do
          it "should remove only his pending or started tpd requests" do
            received_survey_request_ids_by_patient = patient.received_surveys.tpd.pending.map &:id
            post :remove_requests

            expect_json_content
            expect_success_status
            expect(json["status"]).to eq('success')
            expect(received_survey_request_ids_by_patient - UserSurveyForm.all.map(&:id)).to match_array(received_survey_request_ids_by_patient)
          end
        end
      end
    end
  end
end