describe Api::V1::Users::RegistrationsController do

  # Test cases for User Registration
  describe "#create" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    context "when all the params are supplied" do
      context "when all the params are valid" do
        let(:params) do
          {
            :user => {
              :email => "sample-user@example.com",
              :first_name => "Sample",
              :last_name => "User",
              :gender => "Male",
              :country_code => '+91',
              :phone_number => "2356767889",
              :ethnicity => "Human",
              :birthdate => "01/01/1991",
              :password => "password123",
              :password_confirmation => "password123",
              :preferred_device => 'android',
              :time_zone => 'Atlantic'
            }
          }
        end

        context "when no role is present" do
          it "should create patient instance" do
            expect do
              post :create, params
            end
            .to change(User, :count).by(1)

            expect_success_status
            expect_json_content

            expect(json["status"]).to eq("success")
            expect(json["data"]).to include({
              "email" => "sample-user@example.com",
              "first_name" => "Sample",
              "last_name" => "User",
              "gender" => "Male",
              "country_code" => "+91",
              "phone_number" => "2356767889",
              "ethnicity" => "Human",
              "role" => "Patient",
              "preferred_device" => "android",
              "time_zone" => "Atlantic"
            })
          end
        end

        context "when role is physician" do
          before do
            params[:user][:role] = "Physician"
          end

          it "should create physician instance" do
            expect do
              post :create, params
            end
            .to change(User, :count).by(1)

            expect_success_status
            expect_json_content

            expect(json["status"]).to eq("success")
            expect(json["data"]).to include({
              "email" => "sample-user@example.com",
              "first_name" => "Sample",
              "last_name" => "User",
              "gender" => "Male",
              "ethnicity" => "Human",
              "role" => "Physician",
              "country_code" => "+91",
              "phone_number" => "2356767889",
              "preferred_device" => "android",
              "time_zone" => "Atlantic"
            })
          end
        end

        context "when role is support" do
          before do
            params[:user][:role] = "Support"
          end

          it "should create support instance" do
            expect do
              post :create, params
            end
            .to change(User, :count).by(1)

            expect_success_status
            expect_json_content

            expect(json["status"]).to eq("success")
            expect(json["data"]).to include({
              "email" => "sample-user@example.com",
              "first_name" => "Sample",
              "last_name" => "User",
              "gender" => "Male",
              "ethnicity" => "Human",
              "role" => "Support",
              "country_code" => "+91",
              "phone_number" => "2356767889",
              "preferred_device" => "android",
              "time_zone" => "Atlantic"
            })
          end
        end
      end

      context "when some of the params are invalid" do
        let(:params) do
          {
            :user => {
              :first_name => "S",
              :email => "invalid-email",
              :last_name => "User",
              :gender => "Male",
              :birthdate => "something",
              :ethnicity => "Human",
              :password => "password123",
              :password_confirmation => "password1234",
              :phone_number => "invalid",
              :country_code => "invalid country code"
            }
          }
        end

        it "should render error messages for invalid fields" do
          expect do
            post :create, params
          end
          .to_not change(User, :count)

          expect_forbidden_status
          expect_json_content

          expect(json["status"]).to eq("error")
          expect(json["errors"]["full_messages"]).to include(
            "Password confirmation doesn't match password",
            "Email is invalid",
            "Birthdate must be a valid date",
            "Country code is too long (maximum is 5 characters)")
        end
      end
    end

    context "when some of the params are missing" do
      let(:params) do
        {
          :user => {
            :first_name => "Sample",
            :ethnicity => "Human",
            :password_confirmation => "password123"
          }
        }
      end

      it "should render error messages for missing fields" do
        expect do
          post :create, params
        end
        .to_not change(User, :count)

        expect_forbidden_status
        expect_json_content

        expect(json["status"]).to eq("error")
        expect(json["errors"]["full_messages"]).to include(
          "Password can't be blank",
          "Password confirmation doesn't match password",
          "Email is invalid",
          "Gender can't be blank",
          "Last name can't be blank",
          "Birthdate must be a valid date",
          "Phone number is invalid",
          "Country code is too short (minimum is 1 character)"
        )
      end
    end

    context "when none of the params are present" do
      it "should render error messages for all the required fields" do
        expect do
          post :create
        end
        .to_not change(User, :count)

        expect_unprocessable_status
        expect_json_content

        expect(json["status"]).to eq("error")
        expect(json["errors"]).to include("Please submit proper sign up data in request body.")
      end
    end

    context "when something goes wrong while processing the request" do
      before do
        described_class.any_instance
          .stub(:sign_up_params) do
            raise StandardError.new("Something went wrong")
          end
      end

      it "should render human readable error message" do
        expect do
          post :create
        end
        .not_to raise_exception

        expect_server_error_status
        expect_json_content

        expect(json["status"]).to eq("error")
        expect(json["errors"]).to include("Something went wrong")
      end

      after do
        described_class.any_instance
          .unstub(:sign_up_params)
      end
    end
  end

end