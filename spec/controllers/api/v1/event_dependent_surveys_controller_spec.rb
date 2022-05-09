describe Api::V1::EventDependentSurveysController do

  describe '#create' do
    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        post :create

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context "when the user is logged in" do
      context "as physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        before do
          token_sign_in(physician)
        end

        context "when the user attempts to schedule the survey to all his patients" do
          let!(:patient1) { FactoryGirl.create(:user) }
          let!(:patient2) { FactoryGirl.create(:user) }
          let!(:patient3) { FactoryGirl.create(:user) }
          let!(:careteam1) { FactoryGirl.create(:careteam, :patient => patient1) }
          let!(:careteam2) { FactoryGirl.create(:careteam, :patient => patient2) }
          let!(:careteam3) { FactoryGirl.create(:careteam, :patient => patient3) }

          let!(:disease1) { FactoryGirl.create(:disease, :patient => patient1) }
          let!(:disease2) { FactoryGirl.create(:disease, :patient => patient2) }

          let!(:survey) { FactoryGirl.create(:survey, :creator => physician) }

          let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient3) }
          let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan) }
          let(:params) do
            {
              :survey_id => survey.id,
              :time => 50,
              :filters => {
                            :conditions => [ disease1.condition.id, disease2.condition.id ],
                            :therapies => [ treatment_plan_therapy.strain.id ]  }
            }
          end

          before do
            careteam1.add_member(physician)
            careteam2.add_member(physician)
            careteam3.add_member(physician)
          end

          it "should create the survey requests for the patients" do
            post :create, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']).to include(
              {
                "id" => 1,
                "survey" => {
                  "id" => survey.id,
                  "name" => survey.name
                  },
                "time" => params[:time]
              }
            )
          end
        end
      end
    end
  end

  describe "#index" do
    let!(:survey) { FactoryGirl.create(:survey) }

    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        get :index

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context "when the user is logged in" do
      context "as physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        let!(:patient1) { FactoryGirl.create(:user) }
        let!(:patient2) { FactoryGirl.create(:user) }
        let!(:scheduled_survey1) { FactoryGirl.create(:event_dependent_survey, :survey => survey, :physician => physician) }
        let!(:scheduled_survey2) { FactoryGirl.create(:event_dependent_survey, :physician => physician) }

        before do
          token_sign_in(physician)
        end

        context "when the user wants to view all the surveys scheduled by him" do
          before do
            scheduled_survey1.receipients.create(:receiver_id => patient1.id)
          end

          it "should return all the scheduled surveys with the receipients" do
            get :index

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']).to include(
              {
                "id" => scheduled_survey1.id,
                "survey" => {
                  "id" => scheduled_survey1.survey.id,
                  "name" => scheduled_survey1.survey.name
                  },
                "time" => scheduled_survey1.time,
                "receipients" => [
                  UserMinimalSerializer.new(patient1).as_json.stringify_keys
                ]
                },
              {
                "id" => scheduled_survey2.id,
                "survey" => {
                  "id" => scheduled_survey2.survey.id,
                  "name" => scheduled_survey2.survey.name
                  },
                "time" => scheduled_survey2.time,
                "receipients" => []
              }
            )
          end
        end

      end
    end
  end

  describe '#destroy' do
    let!(:scheduled_survey) { FactoryGirl.create(:event_dependent_survey) }

    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        delete :destroy, :id => scheduled_survey.id

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context "when the user is logged in" do
      context "as physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        before do
          token_sign_in(physician)
        end
        context "when the user attemptes to remove the survey" do
          let!(:scheduled_survey) { FactoryGirl.create(:event_dependent_survey, :physician => physician) }
          it "should remove the scheduled survey for the patients" do
            delete :destroy, :id => scheduled_survey.id

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']).to eq('Survey Removed successfully')
            expect(physician.event_dependent_surveys).to be_none { |survey| survey.survey == scheduled_survey.survey }
          end
        end
      end
    end
  end

end