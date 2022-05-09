describe Api::V1::NotificationsController do

  describe '#read' do
    context "when the user is not logged in" do
      context "when the user tries to mark the notification as read" do
        it "should return error 'Authorized users only'" do
          post :read, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      let(:patient) { FactoryGirl.create(:user) }
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let(:notification) { FactoryGirl.create(:notification, :sender => patient, :recipient => physician) }

      before do
        token_sign_in(physician)
      end

      context "when the notification belongs to the user" do
        it "should be marked as read" do
          post :read, :id => notification.id

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data']).to eq('Notification marked as read')
          notification.reload
          expect(notification.status).to eq('seen')
        end
      end

      context "when the notification does not belongs to the user" do
        let(:my_physician) { FactoryGirl.create(:user_with_physician_role) }
        let(:my_notification) { FactoryGirl.create(:notification, :sender => patient, :recipient => my_physician)}

        it "should render an unauthorized error message" do
          post :read, :id => my_notification.id

          expect_unauthorized_access
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to include('Unauthorized access')
        end
      end

      context "when no such notification exists corresponding to the id passed" do
        it "should render error message stating 'No such Notification'" do
          post :read, :id => -1

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to eq('No such Notification')
        end
      end
    end
  end

  describe '#unread' do
    context "when the user is not logged in" do
      context "when the user tries to mark the notification as unread" do
        it "should return error 'Authorized users only'" do
          post :unread, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      let(:patient) { FactoryGirl.create(:user) }
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let(:notification) { FactoryGirl.create(:notification, :sender => patient, :recipient => physician)}

      before do
        token_sign_in(physician)
      end

      context "when the notification belongs to the user" do
        it "should be marked as unread" do
          post :unread, :id => notification.id

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data']).to eq('Notification marked as unread')
          notification.reload
          expect(notification.status).to eq('unseen')
        end
      end

      context "when the notification does not belongs to the user" do
        let(:my_physician) { FactoryGirl.create(:user_with_physician_role) }
        let(:my_notification) { FactoryGirl.create(:notification, :sender => patient, :recipient => my_physician)}

        it "should render an unauthorized error message" do
          post :unread, :id => my_notification.id

          expect_unauthorized_access
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to include('Unauthorized access')
        end
      end

      context "when no such notification exists corresponding to the id passed" do
        it "should render error message stating 'No such Notification'" do
          post :unread, :id => -1

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to eq('No such Notification')
        end
      end
    end
  end

  describe '#ignore' do
    context 'user is not logged in' do
      it 'should render "unauthorized access"' do
        post :ignore
        expect_unauthorized_access
        expect_json_content
      end
    end

    context 'user is logged in' do
      let(:user) { FactoryGirl.create(:user_with_physician_role) }

      before do
        token_sign_in(user)
      end

      context 'key is missing' do
        it 'should render "Key is required"' do
          post :ignore
          expect_success_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to eq('Key is required')
        end
      end

      context 'key is present' do
        context 'key is valid' do
          context 'user doesn"t have any notifications' do
            it 'should render success without any error' do
              post :ignore, :key => :careteam_request_initiated
              expect_success_status
              expect_json_content
              expect(json['status']).to eq('success')
              expect(json['data']).to eq('Notifications ignored successfully')
            end
          end

          context 'user has notifications' do
            let(:careteam) { FactoryGirl.create(:careteam) }
            let!(:careteam_request) do
              FactoryGirl.create(:request, :sender => careteam.patient, :recipient => user)
            end

            it 'should ignore all the notifications and render success' do
              post :ignore, :key => :careteam_request_initiated
              expect(user.received_notifications.unseen).to be_empty
              expect_success_status
              expect_json_content
              expect(json['status']).to eq('success')
              expect(json['data']).to eq('Notifications ignored successfully')
            end
          end
        end

        context 'key is invalid' do
          it 'should render "Invalid key" error' do
            post :ignore, :key => :invalid_key
            expect_success_status
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to eq('Invalid key')
          end
        end
      end
    end
  end

  describe '#index' do
    context "when the user is not logged in" do
      context "when the user tries to access the notifications" do
        it "should return error 'Authorized users only'" do
          get :index

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      let(:patient1) { FactoryGirl.create(:user) }
      let(:patient2) { FactoryGirl.create(:user) }
      let(:physician) { FactoryGirl.create(:user_with_physician_role) }
      let!(:notification1) { FactoryGirl.create(:notification, :sender => patient1, :recipient => physician) }
      let!(:notification2) { FactoryGirl.create(:notification, :sender => patient2, :recipient => physician) }

      before do
        token_sign_in(physician)
      end

      context "when the user tries to access the notifications" do
        it "should return all the unseen notifications for the user" do
          get :index

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data']).to be_all do |hash|
            hash['type'] == 'careteam_request_initiated'
          end
        end
      end

      context "when the user has some seen notifications" do
        before do
          notification2.seen!
        end

        it "should not return the seen notifications" do
          get :index

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data']).to be_all do |hash|
            hash['type'] == 'careteam_request_initiated'
          end
        end
      end
    end

  end

end