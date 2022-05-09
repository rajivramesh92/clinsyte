describe Api::V1::SurveyConfigurationsController do

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
      context "as the patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        it "should return error message stating 'Unauthorized access'" do
          post :create

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as a physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        before do
          token_sign_in(physician)
        end

        context "when the user attempts to create a Survey Configuration" do
          let!(:survey) { FactoryGirl.create(:survey, :creator => physician) }
          let!(:params) do
            {
            :survey_configuration =>
              {
                :survey_id => survey.id,
                :from_date => '01/01/2000',
                :days => 2
              }
            }
          end

          it "should create the Survey Configuration" do
            post :create, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data'].as_json).to include({
              "from_date" => Date.parse(params[:survey_configuration][:from_date]).strftime('%Y-%m-%d').to_s,
              "days" => params[:survey_configuration][:days],
            })
          end
        end
      end
    end
  end

end