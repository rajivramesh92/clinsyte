describe Api::V1::AppointmentPreferencesController do
  
  describe '#toggle_auto_confirm' do
    let(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let!(:appointment_preference) { FactoryGirl.create(:appointment_preference, :physician => physician) }
    let(:params) do
      {
        :appointment_preference => 
          {
            :auto_confirm => true
          }
      }
    end

    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        post :toggle_auto_confirm, params

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context "when the user is logged in" do
      context "as patient" do
        let(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        context "when the user attempts to update the appointment preference" do
          it "should return an error message stating 'Unauthorized access'" do
            post :toggle_auto_confirm, params

            expect_unauthorized_access
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Unauthorized access')
          end
        end
      end

      context "as physician" do
        before do
          token_sign_in(physician)
        end

        context "when the user attempts to update the appointment preference" do
          it "should update the appointment_preference" do
            post :toggle_auto_confirm, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']).to eq('Appointment preferences updated successfully')
          end
        end

      end
    end
  end

end