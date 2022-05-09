describe Api::V1::Users::PasswordsController do

  describe "#create" do
    let(:user) { FactoryGirl.create(:user) }

    context "email or phone number is present" do
      context "email or phone numer is valid" do
        context "email or phone number is verified" do
          before do
            user.email_verify!
          end

          it "should send a verification code" do
            post :create, { :medium => user.email }

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("success")
            expect(json["data"]).to eq("Verification code sent successfully")
          end
        end

        context "email or phone number is not verified" do
          it "should render 'not verified' error" do
            post :create, { :medium => user.email }
            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("error")
            expect(json["errors"]).to eq("Entered email is not verified")
          end
        end
      end

      context "email or phone number is invalid" do
        it "should render 'No user found'" do
          post :create, { :medium => "+919980773344" }
          expect_success_status
          expect_json_content
          expect(json["status"]).to eq("error")
          expect(json["errors"]).to eq("No user found for '+919980773344'")
        end
      end
    end

    context "email and phone number are absent" do
      it "should render 'email or phone number required'" do
        post :create
        expect_success_status
        expect_json_content
        expect(json["status"]).to eq("error")
        expect(json["errors"]).to eq("Email or phone number is required to reset the password")
      end
    end

    context "something went wrong" do
      before do
        described_class.any_instance.stub(:check_for_medium) do
          raise StandardError.new("Something went wrong")
        end
      end

      it "should render humanized error message" do
        expect do
          post :create
        end.
        not_to raise_exception
        expect_server_error_status
        expect_json_content
        expect(json["status"]).to eq("error")
        expect(json["errors"]).to match_array(["Something went wrong"])
      end

      after do
        described_class.any_instance.unstub(:check_for_medium)
      end
    end
  end

  describe "#validate_verification_code" do
    context "verification code is present" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        user.send_email_verification_code
      end

      context "verification code is valid" do
        it "should render 'success' with reset password token" do
          post :validate_verification_code, { :verification_token => user.verification_code }
          expect_success_status
          expect_json_content
          expect(json["status"]).to eq("success")
          expect(json["data"]["reset_password_token"]).to be_present
        end
      end

      context "verification code is invalid" do
        it "should render 'Invalid verification code'" do
          post :validate_verification_code, { :verification_token => "something" }
          expect_success_status
          expect_json_content
          expect(json["status"]).to eq("error")
          expect(json["errors"]).to eq("Verification code is invalid")
        end
      end
    end

    context "verification code is absent" do
      it "should render 'Verification code is required'" do
        post :validate_verification_code
        expect_success_status
        expect_json_content
        expect(json["status"]).to eq("error")
        expect(json["errors"]).to eq("Verification code required to reset the password")
      end
    end
  end

  describe "#reset_password" do
    context "reset password token is present" do
      let(:user) { FactoryGirl.create(:user) }

      context "reset password token is valid" do
        let(:reset_password_token) {
          user.send(:set_reset_password_token)
        }

        context "params are present" do
          context "params are valid" do
            let(:params) {
              {
                :password => "password123",
                :password_confirmation => "password123",
                :reset_password_token => reset_password_token
              }
            }

            it "should update the password" do
              post :reset_password, params
              expect_success_status
              expect_json_content
              expect(json["status"]).to eq("success")
              expect(json["data"]).to eq("Password reset successfully")
            end
          end

          context "params are invalid" do
            let(:params) {
              {
                :password => "invalid",
                :password_confirmation => "something",
                :reset_password_token => reset_password_token
              }
            }

            it "should render 'Invalid params'" do
              post :reset_password, params
              expect_success_status
              expect_json_content
              expect(json["status"]).to eq("error")
              expect(json["errors"]).to include(
                "Password is too short (minimum is 8 characters)",
                "Password confirmation doesn't match password"
              )
            end
          end
        end

        context "params are absent" do
          it "should render 'missing required params'" do
            post :reset_password, :reset_password_token => reset_password_token
            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("success")
          end
        end
      end

      context "reset password token is invalid" do
        it "should render 'Invalid reset password token'" do
          post :reset_password, { :reset_password_token => "something" }
          expect(json["status"]).to eq("error")
          expect(json["errors"]).to eq("Invalid reset password token")
        end
      end
    end

    context "reset password token is absent" do
      it "should render 'Invalid reset password token'" do
        post :reset_password
        expect(json["status"]).to eq("error")
        expect(json["errors"]).to eq("Invalid reset password token")
      end
    end
  end
end