module SearchableSharedExample
  shared_examples_for "searchable" do | resource |
    let(:user) { FactoryGirl.create(:user) }

    context 'No user is signed in' do
      it 'should respond with "Unauthorized"' do
        get :index

        expect_unauthorized_access
        expect_json_content
      end
    end

    context 'user signed in' do
      before do
        token_sign_in(user)
      end

      context 'search keys are present' do
        context 'key is valid' do
          let(:params) do
            { :search => { :name => 'Name' } }
          end

          before do
            FactoryGirl.create_list(resource, 20)
          end

          it 'should render the matching records' do
            get :index, params
            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']).to be_kind_of(Array)
            expect(json['data']).to be_all { |e| e['name'].include?('Name') }
            expect(json['data'].length).to eq(10)
          end
        end

        context 'key is invalid' do
          let(:params) do
            { :search => { :something => "123" } }
          end

          it 'should render \'Invalid Key\'' do
            get :index, params
            expect_success_status
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to eq('Invalid Key: something')
          end
        end
      end

      context 'no search key is not present' do

        before do
          FactoryGirl.create_list(resource, 20)
        end

        it 'should return first 10 records' do
          get :index
          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')
          expect(json['data']).to be_kind_of(Array)
          expect(json['data'].length).to eq(10)
        end
      end
    end
  end
end