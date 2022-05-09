describe Api::V1::Users::SessionsController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "#create" do
    context "when valid credentials passed" do
      let(:user) { FactoryGirl.create(:user, :password => 'Test1234') }

      context "when account is confirmed" do
        before do
          user.email_verify!
        end

        it "should sign in the user with session" do
          post :create, { :email => user.email, :password => 'Test1234' }

          expect_success_status
          expect_json_content
          expect(json["data"]["auth"]["user"]).to include({
            "id" => user.id,
            "email" => user.email
          })
        end
      end

      context "when account is not confirmed" do
        it "should render 'not confirmed' eror" do
          post :create, { :email => user.email, :password => 'Test1234' }

          expect_unauthorized_access
          expect_json_content
          expect(json["errors"]).to match_array([
            "Your email is not confirmed. Click <a href='/resend_confirmation' class='white-link'>here</a> to resend the confirmation."
          ])
        end
      end
    end

    context "when invalid credentials passed" do
      it "should render 'invalid credentials' error" do
        post :create, { :email => "invalid@email.com", :password => 'Test123' }

        expect_unauthorized_access
        expect_json_content
        expect(json["errors"]).to match_array([
          "Invalid login credentials. Please try again."
        ])
      end
    end
  end

  describe "#destroy" do
    context "user signed in" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        token_sign_in(user)
      end

      it "should signout the user" do
        delete :destroy
        expect_success_status
        expect_json_content
        expect(json["success"]).to eq(true)
      end
    end

    context "user not signed in" do
      it "should render humanized error message with 404 status" do
        delete :destroy
        expect_not_found_status
        expect_json_content
        expect(json["errors"]).to match_array([
          "User was not found or was not logged in."
        ])
      end
    end
  end

end