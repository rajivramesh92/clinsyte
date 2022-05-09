describe Api::V1::SlotsController do

  describe '#create' do
    context 'when the user is not logged in' do
      context 'when the user attempts to create a slot' do
        it 'should return error message stating "Authorized users only"' do
          post :create

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context 'when the user is logged in' do
      context 'as Patient' do
        let(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        context 'when the user attempts to create a slot' do
          it 'should return an error message stating "Unauthorized access"' do
            post :create

            expect_unauthorized_access
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Unauthorized access')
          end
        end
      end

      context 'as Physician' do
        let(:physician) { FactoryGirl.create(:user_with_physician_role) }
        before do
          token_sign_in(physician)
        end

        context 'when the user attempts to create a slot with invalid parameters' do
          let(:params) do
            {
              :day => nil,
              :from_time => 72000,
              :to_time => 1000000000000
            }
          end
          it 'should not create the slot and return error messages for invalid fields' do
            post :create, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('To time must be less than 86400')
            expect(json['errors']).to include('Day can\'t be blank')
          end
        end

        context 'when the user attempts to create a record with overlapping time' do
          let(:params) do
            {
              :day => 'monday',
              :from_time => 36000,
              :to_time => 72000
            }
          end
          before do
            FactoryGirl.create(:slot, :physician => physician, :from_time => 50000, :to_time => 80000, :day => 'monday')
          end

          it 'should raise error stating "Slot already exists"' do
            post :create, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Slot already exists')
          end
        end

        context 'when the user attempts to create a record with from_time greater than to_time' do
          let(:params) do
            {
              :day => 'monday',
              :from_time => 72000,
              :to_time => 36000
            }
          end

          it 'should raise error stating "Slot timings are invalid"' do
            post :create, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Slot timings are invalid')
          end
        end

        context 'when the user attempts to create a slot with all correct parameters' do
          let(:params) do
            {
              :day => 'monday',
              :from_time => 36000.0,
              :to_time => 72000.0
            }
          end
          it 'should create the slot for the user' do
            post :create, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']).to include({
              'day' => params[:day],
              'from_time' => params[:from_time],
              'to_time' => params[:to_time]
            })
          end
        end

      end
    end
  end

  describe '#update' do
    let(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let(:slot) { FactoryGirl.create(:slot, :physician => physician) }

    context 'when the user is not logged in' do
      context 'when the user attempts to update a slot' do
        it 'should return error message stating "Authorized users only"' do
          patch :update, :id => slot.id

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context 'when the user is logged in' do
      context 'as Patient' do
        let(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        context 'when the user attempts to update a slot' do
          it 'should return an error message stating "Unauthorized access"' do
            patch :update, :id => slot.id

            expect_unauthorized_access
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Unauthorized access')
          end
        end
      end

      context 'as Physician' do
        before do
          token_sign_in(physician)
        end

        context 'when the user attempts to update a slot with invalid parameters' do
          let(:params) do
            {
              :id => slot.id,
              :day => nil,
              :from_time => nil,
              :to_time => slot.to_time
            }
          end
          it 'should not update the slot and return error messages' do
            patch :update, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('From time is not a number')
            expect(json['errors']).to include('Day can\'t be blank')
          end
        end

        context 'when the user attempts to update a slot with overlapping time' do
          let(:params) do
            {
              :id => slot.id,
              :day => slot.day,
              :from_time => slot.from_time,
              :to_time => slot.to_time
            }
          end

          it 'should raise error stating "Slot already exists"' do
            patch :update, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Slot already exists')
          end
        end

        context 'when the user attempts to update a record with from_time greater than to_time' do
          let(:params) do
            {
              :id => slot.id,
              :day => slot.day,
              :from_time => 7000.0,
              :to_time => 5000.0
            }
          end

          it 'should raise error stating "Slot timings are invalid"' do
            patch :update, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Slot timings are invalid')
          end
        end

        context 'when the user attempts to update a slot which does not belongs to him' do
          let!(:slot2) { FactoryGirl.create(:slot) }
          let(:params) do
            {
              :id => slot2.id,
              :day => slot2.day,
              :from_time => 42000.0,
              :to_time => slot2.to_time
            }
          end

          it 'should raise error stating "Unauthorised access"' do
            patch :update, params

            expect_unauthorized_access
            expect_json_content
            expect(json['status']).to eq('error')
          end
        end

        context 'when the user attempts to update a slot that does not exists' do
          let(:params) do
            {
              :id => 1000
            }
          end

          it 'should return error message stating "Slot does not exist"' do
            patch :update, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Slot does not exist')
          end
        end

        context 'when the user attempts to update a slot with all correct parameters' do
          let(:params) do
            {
              :id => slot.id,
              :day => 'tuesday',
              :from_time => 4200.0,
              :to_time => slot.to_time
            }
          end

          it 'should update the slot for the user' do
            patch :update, params

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']).to include({
              'day' => params[:day],
              'from_time' => params[:from_time],
              'to_time' => params[:to_time]
            })
          end
        end

      end
    end
  end

  describe '#destroy' do
    let(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let(:slot) { FactoryGirl.create(:slot, :physician => physician) }

    context 'when the user is not logged in' do
      context 'when the user attempts to delete a slot' do
        it 'should return error message stating "Authorized users only"' do
          delete :destroy, :id => slot.id

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context 'when the user is logged in' do
      context 'as Patient' do
        let(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        context 'when the user attempts to delete a slot' do
          it 'should return an error message stating "Unauthorized access"' do
            delete :destroy, :id => slot.id

            expect_unauthorized_access
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Unauthorized access')
          end
        end
      end

      context 'as Physician' do
        before do
          token_sign_in(physician)
        end 

        context 'when the user attempts to delete a slot not belonging to him' do
          let!(:slot2) { FactoryGirl.create(:slot) }

          it 'should raise error stating "Unauthorised access"' do
            delete :destroy, :id => slot2.id
            
            expect_unauthorized_access
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Unauthorized access')
          end
        end

        context 'when the user attempts to delete a slot that does not exists' do
          it 'should return error stating "Slot does not exist"' do
            delete :destroy, :id => 100000

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Slot does not exist')
          end
        end

        context 'when the user attempts to delete a slot with all right parameters' do
          it 'should delete the slot successfully' do
            delete :destroy, :id => slot.id

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data']).to include('Slot removed successfully')
          end
        end

      end
    end
  end

end