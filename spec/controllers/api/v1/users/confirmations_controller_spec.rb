describe Api::V1::Users::ConfirmationsController do
  let(:redirect_url) { "http://www.example.com/something" }

  before do
    stub_const('ENV', ENV.to_h.merge!({
      "VERIFICATION_REDIRECT_URL" => redirect_url
    }))
  end

  test_cases = ->(field_name) {

    name = field_name.to_s.titleize.capitalize

    context "verification code is present" do
      let(:user) { FactoryGirl.create(:user) }

      before(:each) do
        user.send("send_#{field_name}_verification_code")
      end

      context "user is already verified" do
        let(:query) {
          { :error => "#{name} is already verified" }.to_query
        }

        before do
          user.send("#{field_name}_verify!")
          user.update(:verification_code => "123")
        end

        it "should render 'already verified'" do
          get field_name, { :verification_token => "123", field_name => user.send(field_name), :redirect => true }

          expect_redirect_status
          expect(response).to redirect_to(redirect_url + "?" + query)
        end
      end

      context "user is not verified" do
        let(:query){
          { :notice => "#{name} is verified successfully" }.to_query
        }

        it "should render 'verification success'" do
          get field_name, { :verification_token => user.verification_code, field_name => user.send(field_name), :redirect => true }

          expect_redirect_status
          expect(response).to redirect_to(redirect_url + "?" + query)
        end
      end

      context "verification token is invalid" do
        let(:query) {
          { :error => "Invalid Credentials" }.to_query
        }

        it "should render 'verification token is invalid'" do
          get field_name, { :verification_token => "something", field_name => user.send(field_name), :redirect => true }

          expect_redirect_status
          expect(response).to redirect_to(redirect_url + "?" + query)
        end
      end
    end

    context "verification code is absent" do
      let(:user) { FactoryGirl.create(:user) }

      let(:query) {
        { :error => "Verification token is required" }.to_query
      }

      it "should render 'verification code is required'" do
        get field_name, { field_name => user.send(field_name), :redirect => true  }

        expect_redirect_status
        expect(response).to redirect_to(redirect_url + "?" + query)
      end
    end

    context "something goes wrong" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        described_class.any_instance.stub(:check_for_token_and_field) do
          raise StandardError.new("Something went wrong")
        end
      end

      it "should render human readable error message" do
        expect do
          get field_name
        end
        .not_to raise_exception

        expect_server_error_status
        expect(json["errors"]).to match_array([
          "Something went wrong"
        ])
      end

      after do
        described_class.any_instance.unstub(:check_for_token_and_field)
      end
    end
  }

  # Email verification
  describe "#email" do
    test_cases.call(:email)
  end

  # Phone number verification
  describe "#phone_number" do
    test_cases.call(:phone_number)
  end

  describe "#resend" do
    context "email is not present" do
      it "should render 'email is required' error" do
        post :resend
        expect_json_content
        expect(json['errors']).to eq('Email is required')
      end
    end

    context "when the email is invalid" do
      it "should not be able to find an account" do
        post :resend, :email => "sms@gmail.com"
        expect_json_content
        expect(json['errors']).to eq('The account does not exist')
      end
    end

    context "when the email is already verified" do
      let(:user) { FactoryGirl.create(:user)  }
      before do
        user.email_verify!
      end
      it "should not be able to resend a message" do
        post :resend, :email => user.email
        expect_json_content
        expect(json['status']).to eq('error')
        expect(json['errors']).to eq('Your account is already verified.')
      end
    end

    context "when the email is not verified" do
      let(:user) { FactoryGirl.create(:user)  }
      it "should be able to resend verification message" do
        post :resend, :email => user.email
        expect_json_content
        expect(json['status']).to eq('success')
        expect(json['data']).to eq(I18n.t('devise.confirmations.send_instructions'))
      end
    end
  end
end
