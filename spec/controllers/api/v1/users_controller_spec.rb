describe Api::V1::UsersController do

  describe '#search' do
    context "when the user is not logged in" do
      context "when the user attempts to access users list" do

        it "should give user unauthorized error" do
          get :search

          expect_json_content
          expect_unauthorized_access
          expect(json["errors"]).to be_present
          expect(json["errors"]).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
       let(:user) { FactoryGirl.create(:user_with_physician_role) }

        before do
          token_sign_in(user)
        end

      context "when the user attempts to access physicians list" do
        it "should return the list of physicians" do
          get :search
          expect_json_content
          expect_success_status
          expect(json["data"]).to be_all { | user | User.find(user['id']).physician? }
        end
      end

      context "when the user attempts to access the physicians list" do
        it "should return the attributes using UserMinimal Serializer" do
          get :search
          expect_json_content
          expect_success_status

          json["data"].each do |user|
            expect(user.keys).to contain_exactly("id", "name", "gender", "role", "location", "admin", "study_admin")
          end
        end
      end

      context "when something goes wrong while processing the request" do
        before do
          described_class.any_instance.stub(:search) do
            raise StandardError.new("Something went wrong")
          end
        end

        it "should return human readble error message" do
          expect do
            get :search
          end
          .not_to raise_exception

          expect_server_error_status
          expect_json_content
          expect(json["status"]).to eq("error")
          expect(json["errors"]).to include("Something went wrong")
        end

        after do
          described_class.any_instance.unstub(:search)
        end
      end
    end
  end

  describe '#show' do

    context "when the user is not logged in" do
      context "when the user attempts to access his profile" do

        it "should return with user unauthorized error" do
          get :show, :id => 1

          expect_json_content
          expect_unauthorized_access

          expect(json["errors"]).to be_present
          expect(json["errors"]).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "when the user attempts to access his profile" do

        let(:user) { FactoryGirl.create(:user) }

        before do
          token_sign_in user
        end

        it "should display profile of the current user" do
          get :show, :id => user.id

          expect_json_content
          expect_success_status

          expect(json["data"]).to include({
            "email" => user.email,
            "first_name" => user.first_name,
            "last_name" => user.last_name,
            "gender" => user.gender,
            "uuid" => user.uuid
            })
        end
      end
    end
  end

  describe '#update' do

    context "when the user is not logged in" do
      context "when the user attempts to update his profile" do

        it "should return with user unauthorized error" do
          patch :update, :id => 1

          expect_json_content
          expect_unauthorized_access

          expect(json["errors"]).to be_present
          expect(json["errors"]).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "when the user attempts to update his profile" do

        let(:user) { FactoryGirl.create(:user) }
        let(:params) do
          {
            :id => user.id,
            :user => {
              :email => "sample-user@example.com",
              :first_name => "Sample",
              :last_name => "User",
              :gender => "Male",
              :phone_number => "2356767889",
              :ethnicity => "Human",
              :password => "password123",
              :password_confirmation => "password123",
              :current_password => user.password
            }
          }
        end

        before do
          token_sign_in user
        end

        it "should update user's profile" do
          patch :update, params

          expect_json_content
          expect_success_status

          expect(json['status']).to eq('success')
          expect(json['data']).to include(
            {
              "email" => 'sample-user@example.com',
              "first_name"=> 'Sample',
              "last_name" => 'User',
              "gender" => 'Male',
              "phone_number" => '2356767889',
              "ethnicity" => 'Human',
              "current_physician" => nil,
              "admin" => false
            })
        end
      end

      context "when the user attempts to update his profile without providing the password" do
        let(:user) { FactoryGirl.create(:user) }
        let(:params) do
          {
            :id => user.id,
            :user => {
              :email => "sample-user@example.com",
              :first_name => "Sample",
              :last_name => "User",
              :gender => "Male",
              :phone_number => "2356767889",
              :ethnicity => "Human",
              :birthdate => "01/01/1991",
              :password => "password123",
              :password_confirmation => "password123"
            }
          }
        end

        before do
          token_sign_in user
        end

        it "should return with an error message stating 'Current password can't be blank'" do
          patch :update, params

          expect_json_content
          expect(json["status"]).to eq("error")
          expect(json["errors"]).to include("Current password can't be blank")
        end
      end

      context "when some of the parameters are not valid" do

        let(:user) { FactoryGirl.create(:user) }
        let(:params) do
          {
            :id => user.id,
            :user => {
              :email => "invalid-email",
              :first_name => "Sample",
              :last_name => "User",
              :gender => "Male",
              :phone_number => "2356767889",
              :ethnicity => "Human",
              :birthdate => "01/01/1991",
              :password => "password123",
              :password_confirmation => "password123",
            }
          }
        end

        before do
          token_sign_in user
        end

        it "should return with an error message" do
          patch :update, params

          expect_json_content
          expect(json["status"]).to eq("error")
          expect(json["errors"]).to include("Email is invalid")
        end
      end
    end
  end

  describe '#qr_code' do
    context 'user is signed in' do
      let(:user) { FactoryGirl.create(:user) }

      before do
        token_sign_in(user)
      end

      context 'valid user id is passed' do
        it 'should return the qr_code as data url' do
          get :qr_code, :id => user.id
          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data']).to be_start_with('data:image/png')
        end
      end

      context 'invalid user id is passed' do
        it 'should render "invalid user" error message' do
          get :qr_code, :id => 0
          expect_success_status
          expect_json_content
          expect(json['status']).to eq('error')
          expect(json['errors']).to eq('User not found')
        end
      end
    end

    context 'user is not signed in' do
      it 'should render unauthorized access' do
        get :qr_code, :id => 0
        expect_unauthorized_access
      end
    end
  end

  describe '#destroy' do

    context "when the user is not logged in" do
      context "when the user attempts to deactivate his profile" do

        it "should return with user unauthorized error" do
          post :destroy, :user_id => 1

          expect_json_content
          expect_unauthorized_access

          expect(json["errors"]).to be_present
          expect(json["errors"]).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "when the user attempts to deactivate his profile" do
        let(:user) do
          FactoryGirl.create(:user, {
            :password => "Test1234",
            :password_confirmation => "Test1234"
          })
        end

        before do
          token_sign_in user
        end

        context "when no password is supplied" do
          it "should render 'password required'" do
            post :destroy, :user_id => user.id

            expect_json_content
            expect_success_status
            expect(user.inactive?).to be(false)
            expect(json['status']).to eq("error")
            expect(json['errors']).to eq("Password is required")
          end
        end

        context "when invalid password is supplied" do
          it "should render 'invalid password'" do
            post :destroy, :user_id => user.id, :password => "something"

            expect_json_content
            expect_success_status
            expect(user.inactive?).to be(false)
            expect(json['status']).to eq("error")
            expect(json['errors']).to eq("Password is invalid")
          end
        end

        context "when valid password is supplied" do
          it "should deactivate his profile" do
            post :destroy, :user_id => user.id, :password => "Test1234"

            expect_json_content
            expect_success_status
            expect(user.reload.inactive?).to be(true)
            expect(json['status']).to eq("success")
            expect(json['data']).to eq("Account deleted successfully")
          end
        end
      end
    end
  end
end
