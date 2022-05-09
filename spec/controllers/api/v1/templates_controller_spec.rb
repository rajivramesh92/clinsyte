describe Api::V1::TemplatesController do

  describe "#create" do
    context "when the user is not logged in" do
      context "when the user tries to create a Template" do
        it "should get an error message" do
          post :create

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "as patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        it "should raise 'Unauthorized access' error" do
          post :create

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        before do
          token_sign_in(physician)
        end

        context "when the user attempts to create a Template" do
          let!(:strain) { FactoryGirl.create(:strain) }
          let(:params) do
            {
              :template => {
                :strain_id => strain.id,
                :name => 'Template 1',
                :template_data_attributes => {
                  :message => 'A random message for Template 1'
                }
              }
            }
          end

          it "should create the template for the user with Template data" do
            post :create, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']).to eq('Template saved successfully')
            expect(physician.templates.map { |template| template.name }).to include(params[:template][:name])
            expect(physician.templates.last.template_data).not_to be_nil
          end
        end

        context "when the user attempts to create a template with some invalid parameters" do
          let(:params) do
            {
              :template => {
                :strain_id => nil,
                :name => 'Template 1',
                :template_data_attributes => {
                  :message => nil
                }
              }
            }
          end

          it "should not create the template for the user" do
            post :create, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include("Strain can't be blank")
          end
        end
      end
    end
  end

  describe "index" do
    context "when the user is not logged in" do
      context "when the user tries to create a Template" do
        it "should get an error message" do
          get :index

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "as patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        it "should raise 'Unauthorized access' error" do
          get :index

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        before do
          token_sign_in(physician)
        end

        context "when the user attempts to view all his templates" do
          let!(:template1) { FactoryGirl.create(:template, :creator => physician) }
          let!(:template_data1) { FactoryGirl.create(:template_datum, :template => template1) }
          let!(:template2) { FactoryGirl.create(:template, :creator => physician) }
          let!(:template_data2) { FactoryGirl.create(:template_datum, :template => template2) }

          it "should return all the templates created by him" do
            get :index

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("success")

            expect(json["data"].map { |template| template['name'] } ).to include(template1.name, template2.name)
          end
        end
      end
    end
  end

  describe "update" do
    context "when the user is not logged in" do
      context "when the user attempts to update template data" do
        it "should get an error message" do
          put :update, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "as patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        it "should raise 'Unauthorized access' error" do
          put :update, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        let!(:template) { FactoryGirl.create(:template, :creator => physician) }
        let!(:template_data) { FactoryGirl.create(:template_datum, :template => template) }
        let(:params) do
          {
            :id => template.id,
            :template => {
              :template_data_attributes => {
                :message => "Sample message for Template"
              }
            }
          }
        end

        before do
          token_sign_in(physician)
        end

        context "when the user attempts to update template data" do
          it "should update the template data" do
            put :update, params

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("success")
            expect(json["data"]).to eq("Template updated successfully")
            expect(template.template_data.message).to eq(params[:template][:template_data_attributes][:message])
          end
        end

        context "when the user attempts to update a template not created by him" do
          let!(:template2) { FactoryGirl.create(:template) }
          before do
            params[:id] = template2.id
          end

          it "should render error stating Update unsuccessfull" do
            put :update, params

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("error")
            expect(json["errors"]).to include("No such Template")
          end
        end
      end
    end
  end

  describe "destroy" do
    context "when the user is not logged in" do
      context "when the user attempts to destroy a template" do
        it "should get an error message" do
          delete :destroy, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "as patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        it "should raise 'Unauthorized access' error" do
          post :toggle_access_level, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        let!(:template) { FactoryGirl.create(:template, :creator => physician) }
        let!(:template_data) { FactoryGirl.create(:template_datum, :template => template) }

        before do
          token_sign_in(physician)
        end

        context "when the user attempts to remove a template" do
          it "should remove the template and data assosiated with it" do
            delete :destroy, :id => template.id

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("success")
            expect(json["data"]).to eq("Template removed successfully")
            expect(physician.templates.map(&:id)).not_to include(template.id)
            expect(template.template_data).to be(nil)
          end
        end

        context "when the user attempts to remove a template not created by him" do
          let!(:my_template) { FactoryGirl.create(:template) }

          it "should return an error message stating 'No such Template'" do
            delete :destroy, :id => my_template.id

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("error")
            expect(json["errors"]).to include("No such Template")
          end
        end
      end

    end
  end

  describe "toggle_access_level" do
    context "when the user is not logged in" do
      context "when the user attempts to change the access level for the template" do
        it "should get an error message" do
          post :toggle_access_level, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "as patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        it "should raise 'Unauthorized access' error" do
          post :toggle_access_level, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        let!(:template) { FactoryGirl.create(:template, :creator => physician) }
        let(:params) do
          {
            :id => template.id,
            :access_level => 'shared'
          }
        end
        before do
          token_sign_in(physician)
        end

        context "when the user attempts to change the access level for a template" do
          it "should change the access level for that template" do
            post :toggle_access_level, params

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("success")
            expect(json["data"]).to eq("Template access level changed to 'shared'")
            expect(template.reload.access_level).to eq('shared')
          end
        end

        context "when the user attempts to change the access level for a template not created by him" do
          let!(:my_template) { FactoryGirl.create(:template) }
          before do
            params[:id] = my_template.id
          end

          it "should return an error message stating 'No such Template'" do
            post :toggle_access_level, params

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("error")
            expect(json["errors"]).to include("No such Template")
            expect(template.reload.access_level).to eq('personal')
          end
        end

        context "when the user attempts to change access level with some invalid data" do
          before do
            params[:access_level] = 'sample' 
          end

          it "should render error stating 'Access Level Toggling unsuccessfull'" do
            post :toggle_access_level, params

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("error")
            expect(json["errors"]).to include("Access Level Toggling unsuccessfull")
            expect(template.reload.access_level).to eq('personal')
          end
        end

      end
    end
  end

  describe "check_availabilty" do
    context "when the user is not logged in" do
      context "when the user attempts to check the availabilty of the Template name" do
        it "should get an error message" do
          get :check_availability

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "as patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        it "should raise 'Unauthorized access' error" do
          get :check_availability

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        before do
          token_sign_in(physician)
        end

        context "when the user attempts to check the availability of the name for the Template" do
          let!(:template1) { FactoryGirl.create(:template, :creator => physician, :name => "Sample template") }
          let!(:template2) { FactoryGirl.create(:template, :creator => physician, :name => "Random Template") }

          it "should return true if name is available" do
            get :check_availability, :name => "My Template"

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("success")
            expect(json["data"]).to eq(true)
          end

          it "should return false if name is not available" do
            get :check_availability, :name => "Sample"

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("success")
            expect(json["data"]).to eq(false)
          end
        end

        context "when the name is not passed properly" do
          context "name sent is blank" do
            it "should return error 'Name was sent blank'" do
              get :check_availability, :name => ""

              expect_success_status
              expect_json_content
              expect(json["status"]).to eq("error")
              expect(json["errors"]).to include("Name was sent blank")
            end
          end
        end
      end
    end
  end

end