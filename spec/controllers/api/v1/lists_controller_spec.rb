describe Api::V1::ListsController do

  describe "#create" do
    context "when the user is not logged in" do
      it "should return error 'Authorized users only'" do
        post :create

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context "when the user is logged in" do
      context "as patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        it "should return error stating 'Unauthorized access'" do
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

        it "should return error stating 'Unauthorized access'" do
          post :create

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as admin" do
        let!(:admin) { FactoryGirl.create(:user_with_admin_role) }
        let(:params) do
          {
            :name => 'List 1',
            :options_attributes => [
              {
                :name => 'Option 1'
              },
              {
                :name => 'Option 2'
              }
            ]
          }
        end

        before do
          token_sign_in(admin)
        end

        it "should create the list with options" do
          post :create, params

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(List.last.name).to eq(params[:name])
          options_array = [ params[:options_attributes][0][:name], params[:options_attributes][1][:name] ]
          expect(List.last.options.map(&:name)).to match_array(options_array)
        end
      end
    end
  end

  describe "index" do
    context "when the user is logged in" do
      context "as patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        it "should return error stating 'Unauthorized access'" do
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

        it "should return error stating 'Unauthorized access'" do
          get :index

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as admin" do
        let!(:admin) { FactoryGirl.create(:user_with_admin_role) }

        before do
          token_sign_in(admin)
        end

        context "when the user attempts to get all the Lists" do
          let!(:list1) { FactoryGirl.create(:list, :options_attributes => [{:name => 'option 1'}, { :name => 'option 2'}]) }
          let!(:list2) { FactoryGirl.create(:list, :options_attributes => [{:name => 'option 3'}, { :name => 'option 4'}]) }

          it "should return all the lists with their options" do
            get :index

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')

            list_with_options_array = json['data'].map { |list| {:id => list['id'], :options => list['options'].map { |option| option['id']}}}
            expect(list_with_options_array).to match_array(List.all.map { |list| { :id => list.id, :options => list.options.map(&:id) } })
          end
        end
      end
    end
  end

  describe '#update' do
    context "when the user is logged in" do
      context "as patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        it "should return error stating 'Unauthorized access'" do
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

        it "should return error stating 'Unauthorized access'" do
          get :index

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as admin" do
        let!(:admin) { FactoryGirl.create(:user_with_admin_role) }

        before do
          token_sign_in(admin)
        end

        context "when the user attempts to change the name of the list or options" do
          let!(:list1) { FactoryGirl.create(:list, :options_attributes => [{:name => 'option 1'}, { :name => 'option 2'}]) }
          let(:params) do
            {
              :id => list1.id,
              :name => "Demo List",
              :options_attributes => [
                {
                  :id => list1.options.first.id,
                  :name => list1.options.first.name
                },
                {
                  :id => list1.options.last.id,
                  :name => 'Test Option'
                }
              ]
            }
          end

          it "should update the names" do
            put :update, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(list1.reload.name).to eq(params[:name])
            expect(list1.options.last.name).to eq(params[:options_attributes][1][:name])
          end
        end

        context "when the user attempts to remove some option" do
          let!(:list1) { FactoryGirl.create(:list, :options_attributes => [{:name => 'option 1'}, { :name => 'option 2'}]) }
          let(:params) do
            {
              :id => list1.id,
              :name => list1.name,
              :options_attributes => [
                {
                  :id => list1.options.first.id,
                  :name => list1.options.first.name,
                  :status => 'inactive'
                },
                {
                  :id => list1.options.last.id,
                  :name => list1.options.last.name
                }
              ]
            }
          end

          it "should remove the option from the list" do
            put :update, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            removed_option_id = params[:options_attributes][0][:id]
            expect(list1.reload.options.map(&:id)).not_to include(removed_option_id)
            # To do => Something worng here with enum and scoping
            expect( Option.unscoped { list1.options.all.map(&:id) } ).to include(removed_option_id)
          end
        end

        context "when the user attempts to alter the record with some invalid parameters" do
          let!(:list1) { FactoryGirl.create(:list, :options_attributes => [{:name => 'option 1'}, { :name => 'option 2'}]) }
          let(:params) do
            {
              :id => list1.id,
              :name => list1.name,
              :options_attributes => [
                {
                  :id => list1.options.first.id,
                  :name => list1.options.first.name,
                  :status => 'remove'
                },
                {
                  :id => list1.options.last.id,
                  :name => list1.options.last.name
                }
              ]
            }
          end

          context "when the status provided is invalid" do
            it "should return error" do
              put :update, params

              expect_success_status
              expect_json_content
              expect(json['status']).to eq('error')
            end
          end

          context "when the list id is invalid" do
            before do
              params[:id] = -100
            end

            it "kcdv" do
              put :update, params

              expect_success_status
              expect_json_content
              expect(json['status']).to eq('error')
              expect(json['errors']).to include('List not found')
            end
          end
        end
      end
    end
  end

  describe "#destroy" do
    context "when the user is logged in" do
      let!(:admin) { FactoryGirl.create(:user_with_admin_role) }

      before do
        token_sign_in(admin)
      end

      context "when the user attempts to destroy a List" do
        let!(:list1) { FactoryGirl.create(:list, :options_attributes => [{:name => 'option 1'}, { :name => 'option 2'}]) }

        it "should soft delete the List" do
          delete :destroy, :id => list1.id

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data']).to eq('List removed successfully')
          expect(List.all.map(&:name)).to be_none{ list1.name }
          expect(List.unscoped.all.map(&:name)).to be_present
        end
      end
    end

  end

end