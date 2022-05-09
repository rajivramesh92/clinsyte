describe Api::V1::PhysiciansController do
  describe "#update" do

    context "User is not logged in" do
      it "should return unauthorized" do
        put :update, :id => 1
        expect_unauthorized_access
        expect_json_content
      end
    end

    context "User is logged in" do
      context "User is a patient" do
        let(:user) { FactoryGirl.create(:user) }

        before do
          token_sign_in user
        end

        it "should return unauthorized" do
          put :update, :id => user.id
          expect_unauthorized_access
          expect_json_content
          expect(json["status"]).to eq("error")
          expect(json["errors"]).to include("Unauthorized access")
        end
      end

      context "User is a Physician" do
        let(:user) { FactoryGirl.create(:user_with_physician_role) }

        before do
          token_sign_in user
        end

        context "Params are present" do
          let(:params) do
            {
              :id => user.id,
              :physician => {
                :license_id => "123456",
                :expiry => Date.current
              }
            }
          end

          it "should update the data" do
            put :update, params
            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("success")
            expect(json["data"]).to eq("Profile updated successfully")
          end
        end

        context "Params are not present" do
          it "should return success status" do
            put :update, :id => user.id
            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("success")
            expect(json["data"]).to eq("Profile updated successfully")
          end
        end
      end
    end

  end

  describe '#slots' do
    context 'when the user is not logged in' do
      context 'when the user attempts to view the slots' do
        let(:physician) { FactoryGirl.create(:user_with_physician_role) }
        it 'should return error message stating "Authorized users only"' do
          get :slots, :id => physician.id

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

        context 'when the user attempts to view the slots' do
          let(:physician) { FactoryGirl.create(:user_with_physician_role) }
          let!(:slot) { FactoryGirl.create(:slot, :physician => physician) }

          context 'when include_busy is true' do
            it 'should return all free and busy slots' do
              get :slots, :id => physician.id, :include_busy => true

              expect_success_status
              expect_json_content
              expect(json['status']).to eq('success')
              expect(json['data'].keys - ['free_slots', 'busy_slots']).to be_empty
            end
          end

          context 'when include busy is false' do
            it 'should return all the free slots"' do
              get :slots, :id => physician.id

              expect_success_status
              expect_json_content
              expect(json['status']).to eq('success')
              expect(json['data'].map { |slot| slot['id']} ).to eq(physician.slots.map(&:id))
            end
          end
        end
      end

      context 'as Physician' do
        let(:physician) { FactoryGirl.create(:user_with_physician_role) }
        before do
          token_sign_in(physician)
        end

        context 'when the user attempts to view the slots' do
          before do
            physician2 = FactoryGirl.create(:user_with_physician_role)
            FactoryGirl.create(:slot, :physician => physician, :from_time => 2000, :to_time => 4000)
            FactoryGirl.create(:slot, :physician => physician, :from_time => 6000, :to_time => 8000)
            FactoryGirl.create(:slot, :physician => physician2)
          end
          it 'should return all his slots' do
            get :slots, :id => physician.id

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data'].map { |slot| slot['id'] }).to eq(physician.slots.map(&:id))
          end
        end

        context 'when the user attempts to view the slots' do
          before do
            physician2 = FactoryGirl.create(:user_with_physician_role)
            FactoryGirl.create(:slot, :physician => physician, :from_time => 2000, :to_time => 4000, :day => 'saturday')
            FactoryGirl.create(:slot, :physician => physician, :from_time => 6000, :to_time => 8000, :day => 'thursday')
            FactoryGirl.create(:slot, :physician => physician, :from_time => 8000, :to_time => 9000, :day => 'monday')
          end
          it 'should return all his slots in ascending order of the days' do
            get :slots, :id => physician.id

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('success')
            expect(json['data'].map { |slot| slot['id'] }).to eq(physician.slots.map(&:id))
            expect(json['data'].map { |slot| slot['day'] }).to eq(['monday', 'thursday', 'saturday'])
          end
        end        

        context 'when the user attempts to view the slots with some invalid physician id' do
          it 'should return error message stating "Invalid user"' do
            get :slots, :id => -1

            expect_success_status
            expect_json_content
            expect(json['status']).to eq('error')
            expect(json['errors']).to include('Invalid user')
          end
        end
      end
    end

  end

end