describe Api::V1::PatientsController do
  describe '#select_physician' do
    context "when the user is not logged in" do 
      context "when the user tries to chooose a physician" do
        it "should get error message" do
          post :select_physician, :id => 1, :physician_id => 2

          expect_unauthorized_access
          expect_json_content

          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "when the user to assign as physician is not a physician" do
        let(:user_patient) { FactoryGirl.create(:user) } 

        before do
          token_sign_in(user_patient)
        end

        it "should return with an error stating 'Invalid Physician'" do
          post :select_physician , :id => user_patient.id, :physician_id => 0

          expect_success_status
          expect_json_content

          expect(json['status']).to eq('error')
          expect(json['errors']).to eq('Invalid physician')
        end
      end

      context "when the user is not a patient" do
        let(:physician) { FactoryGirl.create(:user_with_physician_role) }

        before do
          token_sign_in(physician)
        end

        it "should return with an error stating 'Unauthorized access'" do
          post :select_physician, :id => physician.id, :physician_id => physician.id

          expect_unauthorized_access
          expect_json_content

          expect(json['status']).to eq('error')
          expect(json['errors']).to include('Unauthorized access')
        end
      end

      context "when user is a patient and physician already exists in the careteam" do
        let(:patient) { FactoryGirl.create(:user) }
        let(:physician) { FactoryGirl.create(:user_with_physician_role) }

        before do
          token_sign_in(patient)
        end

        it "should update the physician successfully" do
          post :select_physician, :id => patient.id, :physician_id => physician.id
          expect_success_status
          expect_json_content

          expect(json['status']).to eq('success')
          expect(json['data']).to eq('Physician updated successfully')
        end
      end

      context "when something goes wrong while processing the request" do
        let(:patient) { FactoryGirl.create(:user) }
        let(:physician) { FactoryGirl.create(:user_with_physician_role) }

        before do
          token_sign_in(patient)
        end

        before do
          described_class.any_instance
          .stub(:select_physician) do
            raise StandardError.new("Something went wrong")
          end
        end

        it "should return human redable error" do
          expect do
            post :select_physician, :id => patient.id , :physician_id => physician.id
          end
          .not_to raise_exception

          expect_server_error_status
          expect_json_content

          expect(json["status"]).to eq("error")
          expect(json["errors"]).to include("Something went wrong")
        end
      end 
    end
  end 

  describe '#physician' do

    context "when the user is not logged in" do 
      context "when the user tries to access the physician" do
        it "should get error message" do
          post :physician, :id => 1, :physician_id => 2

          expect_unauthorized_access
          expect_json_content

          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in " do 
      let(:user_patient) { FactoryGirl.create(:user) } 
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let!(:careteam) { FactoryGirl.create(:careteam, :patient => user_patient) }

      before do
        token_sign_in(user_patient)
      end

      context "when the physician has already been assigned to the patient" do 
        before do
          careteam.add_physician(physician)
        end

        it "should return the physician's details" do
          get :physician , :id => user_patient.id

          expect_success_status
          expect_json_content

          expect(json["data"]).to include({
            "email" => physician.email , 
            "first_name" => physician.first_name , 
            "last_name" => physician.last_name , 
            "uuid" => physician.uuid
          })
        end
      end

      context "when the physician has not been assigned yet" do
        it "should return with a message 'No physician selected yet'" do
          get :physician , :id => user_patient.id

          expect_success_status
          expect_json_content

          expect(json['status']).to eq('error')
          expect(json['errors']).to eq('No physician selected yet')
        end
      end
    end
  end


  describe '#deselect_physician' do
    context "when the user is not logged in" do 
      context "when the user tries to de-select a physician" do
        it "should get error message" do
          get :deselect_physician , :id => 1

          expect_unauthorized_access
          expect_json_content

          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do 
      let(:user_patient) { FactoryGirl.create(:user) }
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }
      
      before do
        token_sign_in(user_patient)
      end

      context "when the user tries to deselect a physician when it has not been selected yet" do
        it "should return with an error stating 'Need to select a physician before de-selecting'" do
          get :deselect_physician , :id => user_patient.id

          expect_success_status
          expect_json_content

          expect(json['status']).to eq('error')
          expect(json['errors']).to eq("Need to select a physician before de-selecting")
        end
      end

      context "when the user is not a patient" do
        it "should return with an error stating 'Unauthorized access'" do
          get :deselect_physician , :id => -1

          expect_unauthorized_access
          expect_json_content

          expect(json['status']).to eq('error')
          expect(json['errors']).to include('Unauthorized access')
        end
      end

      context "when physician has been selected and patient wants to deselect it" do
        let(:careteam) { FactoryGirl.create(:careteam, :patient => user_patient) }

        before do
          careteam.add_physician(physician)
        end

        it "should deselect the physician and return message 'Physician deselected successfully'" do
          get :deselect_physician , :id => user_patient.id

          expect_success_status
          expect_json_content

          expect(json['status']).to eq('success')
          expect(json['data']).to eq('Physician deselected successfully')
        end
      end

      context "when something goes wrong while processing the request" do
        before do
          described_class.any_instance
          .stub(:deselect_physician) do
            raise StandardError.new("Something went wrong")
          end
        end

        it "should return human readble error" do
          expect do
            get :deselect_physician, :id => user_patient.id
          end
          .not_to raise_exception

          expect_server_error_status
          expect_json_content

          expect(json["status"]).to eq("error")
          expect(json["errors"]).to include("Something went wrong")
        end
      end
    end
  end
end
