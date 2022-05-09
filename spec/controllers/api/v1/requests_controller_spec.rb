describe Api::V1::RequestsController do

  describe '#create' do
    context "when the user is not logged in" do
      context "when the user tries to choose a physician" do
        it "should get error message" do
          post :create , :recipient_id => 1

          expect_unauthorized_access
          expect_json_content

          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in as patient" do
      let(:patient) { FactoryGirl.create(:user) }
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }

      before do
        token_sign_in(patient)
      end

      context "when the user attempts to choose a physician" do
        it "should create a connection_request for that physician" do
          expect do
            post :create , :recipient_id => physician.id
          end.to change(Request, :count).by(1)

          connection_request = Request.last
          notification = Notification.last
          expect_success_status
          expect_json_content

          expect(json['status']).to eq('success')
          expect(json['data']).to eq(RequestSerializer.new(Request.last).as_json.deep_stringify_keys)
          expect(connection_request.sender).to eq(patient)
          expect(connection_request.recipient).to eq(physician)
          expect(connection_request.status).to eq('pending')

          expect(notification.sender).to eq(patient)
          expect(notification.recipient).to eq(physician)
          expect(notification.status).to eq('unseen')
          expect(notification.category).to eq('careteam_request_initiated')
        end
      end

      context "when there is no such physician for the physician id provided" do
        it "should render an error message stating 'No such user exists to send the request'" do
          post :create, :recipient_id => -1

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to eq('No such user exists to send the request')
        end
      end

      context "when the connection_request has already been created for the patient" do
        let!(:connection_request) {
          FactoryGirl.create(:request, :sender => patient, :recipient => physician)
        }

        it "should render an error message stating 'Already connection_requested'" do
          post :create , :recipient_id => physician.id

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to eq('Already invited to the careteam')
        end
      end
    end

    context "when the user is logged in as a physician" do
      let(:patient) { FactoryGirl.create(:user) }
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }

      before do
        token_sign_in(physician)
      end

      context "when the user attempts to invite a patient" do
        it "should create the request and initiation notification" do
          expect do
            post :create , :recipient_id => patient.id
          end.to change(Request, :count).by(1)

          connection_request = Request.last
          notification = Notification.last
          expect_success_status
          expect_json_content

          expect(json['status']).to eq('success')
          expect(json['data']).to eq(RequestSerializer.new(Request.last).as_json.deep_stringify_keys)
          expect(connection_request.sender).to eq(physician)
          expect(connection_request.recipient).to eq(patient)
          expect(connection_request.status).to eq('pending')

          expect(notification.sender).to eq(physician)
          expect(notification.recipient).to eq(patient)
          expect(notification.status).to eq('unseen')
          expect(notification.category).to eq('careteam_join_request_initiated')
        end
      end

      context "when the connection_request has already been created for the patient" do
        let!(:connection_request) {
          FactoryGirl.create(:request, :sender => physician, :recipient => patient)
        }

        it "should render an error message stating 'Already connection_requested'" do
          post :create , :recipient_id => patient.id

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to eq('Already invited to the careteam')
        end
      end
    end
  end

  describe '#update' do
    context "when the user is not logged in" do
      context "when the user tries to choose a physician" do
        it "should get error message" do
          post :create , :id => 1

          expect_unauthorized_access
          expect_json_content

          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in as physician" do
      let(:patient) { FactoryGirl.create(:user) }
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }

      before do
        token_sign_in(physician)
      end

      context "when a physician attempts to respond to a connection_request" do
        let(:connection_request) {
          FactoryGirl.create(:request, :sender => patient, :recipient => physician)
        }

        it "should update the connection_request with accept status" do
          patch :update, :id => connection_request.id, :status => 'accept'

          expect_success_status
          expect_json_content

          expect(json['status']).to eq('success')
          sender = connection_request.sender
          recipient = connection_request.recipient

          expect(json['data']).to include(
            {
              "id" => connection_request.id,
              "sender" => UserMinimalSerializer.new(sender).as_json.stringify_keys,
              "recipient" => UserMinimalSerializer.new(recipient).as_json.stringify_keys,
              "status" => "accepted"
            })

          connection_request.reload
          expect(connection_request.status).to eq('accepted')

          notification = Notification.first
          expect(notification.sender).to eq(physician)
          expect(notification.recipient).to eq(patient)
          expect(notification.status).to eq('unseen')
          expect(notification.category).to eq('careteam_request_accepted')
        end

        it "should update the connection_request with declined status" do
          patch :update, :id => connection_request.id, :status => 'decline'

          expect_success_status
          expect_json_content

          expect(json['status']).to eq('success')

          sender = connection_request.sender
          recipient = connection_request.recipient
          expect(json['data']).to include(
            {
              "id" => connection_request.id,
              "sender" => UserMinimalSerializer.new(sender).as_json.stringify_keys,
              "recipient" => UserMinimalSerializer.new(recipient).as_json.stringify_keys,
              "status" => "declined"
            })

          connection_request.reload
          expect(connection_request.status).to eq('declined')

          notification = Notification.first
          expect(notification.sender).to eq(physician)
          expect(notification.recipient).to eq(patient)
          expect(notification.status).to eq('unseen')
          expect(notification.category).to eq('careteam_request_declined')
        end
      end

      context "when a physician attempts to respond to a connection_request with some wrong status" do
        let(:connection_request) {
          FactoryGirl.create(:request, :sender => patient, :recipient => physician)
        }

        it "should render an error stating 'Invalid Status'" do
          patch :update , :id =>  connection_request.id, :status => 'xyz'

          expect_success_status
          expect_json_content

          expect(json['status']).to eq('error')
          expect(json['errors']).to eq('Invalid Status')
        end
      end
    end

    context 'when the user is logged in as patient' do
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let(:patient) { FactoryGirl.create(:user) }
      let(:careteam_request) { FactoryGirl.create(:request, :sender => physician) }

      before do
        token_sign_in(patient)
      end

      context 'when the patient attempts to respond to a request' do
        let(:connection_request) {
          FactoryGirl.create(:request, :sender => physician, :recipient => patient)
        }

        it "should update the connection_request with accept status" do
          patch :update, :id => connection_request.id, :status => 'accept'

          expect_success_status
          expect_json_content

          expect(json['status']).to eq('success')

          sender = connection_request.sender
          recipient = connection_request.recipient
          expect(json['data']).to include(
            {
              "id" => connection_request.id,
              "sender" => UserMinimalSerializer.new(sender).as_json.stringify_keys,
              "recipient" => UserMinimalSerializer.new(recipient).as_json.stringify_keys.merge({"careteam_id" => recipient.careteam.id}),
              "status" => "accepted"
            })

          connection_request.reload
          expect(connection_request.status).to eq('accepted')

          notification = Notification.first
          expect(notification.sender).to eq(patient)
          expect(notification.recipient).to eq(physician)
          expect(notification.status).to eq('unseen')
          expect(notification.category).to eq('careteam_join_request_accepted')
        end

        it "should update the connection_request with declined status" do
          patch :update, :id => connection_request.id, :status => 'decline'

          expect_success_status
          expect_json_content

          expect(json['status']).to eq('success')

          sender = connection_request.sender
          recipient = connection_request.recipient
          expect(json['data']).to include(
            {
              "id" => connection_request.id,
              "sender" => UserMinimalSerializer.new(sender).as_json.stringify_keys,
              "recipient" => UserMinimalSerializer.new(recipient).as_json.stringify_keys.merge({"careteam_id" => recipient.careteam.id}),
              "status" => "declined"
            })
          connection_request.reload
          expect(connection_request.status).to eq('declined')

          notification = Notification.first
          expect(notification.sender).to eq(patient)
          expect(notification.recipient).to eq(physician)
          expect(notification.status).to eq('unseen')
          expect(notification.category).to eq('careteam_join_request_declined')
        end
      end
    end
  end

  describe '#show' do
    context "when the user is not logged in" do
      context "when the user tries to choose a physician" do
        it "should get error message" do
          get :show, :id => 1

          expect_unauthorized_access
          expect_json_content

          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in as physician" do
      let(:patient) { FactoryGirl.create(:user) }
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }

      before do
        token_sign_in(physician)
      end

      context "when the user attempts to access the connection_request" do
        let(:connection_request) {
          FactoryGirl.create(:request, :sender => patient, :recipient => physician)
        }

        it "should give the connection_request details for the particular connection_request id" do
          get :show , :id => connection_request.id

          expect_success_status
          expect_json_content

          expect(json["data"]).to include({
            "id" => connection_request.id,
            "sender" => UserMinimalSerializer.new(connection_request.sender).as_json.stringify_keys,
            "recipient" => UserMinimalSerializer.new(connection_request.recipient).as_json.stringify_keys,
            "status" => connection_request.status
          })
        end
      end

      context "when no such connection_request exists for the connection_request id provided" do
        it "should render an error message stating 'No such record'" do
          get :show, :id => -1

          expect_not_found_status
          expect_json_content

          expect(json["status"]).to eq("error")
          expect(json["errors"]).to include("No such record")
        end
      end
    end
  end


  describe '#index' do
    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        get :index
        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end


    context "when the user is logged in as patient" do
      let(:patient) { FactoryGirl.create(:user) }

      before do
        token_sign_in(patient)
      end

      it "should return error 'Unauthorized access'" do
        get :index
        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Unauthorized access")
      end
    end

    context "when the user is logged in as physician" do
      let(:patient1) { FactoryGirl.create(:user) }
      let(:patient2) { FactoryGirl.create(:user) }
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let!(:request1) { FactoryGirl.create(:request, :sender => patient1, :recipient => physician)}
      let!(:request2) { FactoryGirl.create(:request, :sender => patient2, :recipient => physician)}

      before do
        token_sign_in(physician)
      end

      context "when all the requests are pending" do
        it "should return all the pending requests for the physician" do
          get :index
          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data']).to be_all { |e| e['status'] == 'pending' }
        end
      end

      context "when the user has some accepted or declined notifications" do
        before do
          request2.accepted!
        end

        it "should not return the accepted or declined requests" do
          get :index
          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data']).to be_all { |e| e['status'] == 'pending' }
        end
      end
    end
  end
end