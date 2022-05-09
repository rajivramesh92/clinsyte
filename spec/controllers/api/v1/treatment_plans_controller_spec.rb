describe Api::V1::TreatmentPlansController do

  describe '#change_owner' do
    context "when the user is not logged in" do
      context "when the user attempts to change the owner for the Treatment Plan" do
        it "should get an error message" do
          post :change_owner, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "as patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient) }
        before do
          token_sign_in(patient)
        end

        it "should render an error message" do
          post :change_owner, :id => treatment_plan.id

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

        context "when user attempts to change the owner for an Orphaned treatment plan" do
          let!(:physician1) { FactoryGirl.create(:user_with_physician_role) }
          let!(:patient1) { FactoryGirl.create(:user) }
          let!(:patient1_careteam) { FactoryGirl.create(:careteam, :patient => patient1) }

          # This is a orphaned treatment plan as the "physician1" is not a part of patient1's careteam
          let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient1, :creator => physician1) }

          before do
            patient1_careteam.add_member(physician)
          end

          it "should change the owner for the treatment plan as currently looged in user" do
            post :change_owner, :id => treatment_plan.id

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("success")
            expect(treatment_plan.reload.creator).to eq(physician)
          end
        end

        context "when user attempts to change the owner for an Un-Orphaned treatment plan" do
          let!(:physician1) { FactoryGirl.create(:user_with_physician_role) }
          let!(:patient1) { FactoryGirl.create(:user) }
          let!(:patient1_careteam) { FactoryGirl.create(:careteam, :patient => patient1) }

          # This is a Unorphaned treatment plan as the "physician1" is not a part of patient1's careteam
          let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient1, :creator => physician1) }

          before do
            patient1_careteam.add_member(physician1)
            patient1_careteam.add_member(physician1)
          end

          it "should not change the owner and render an error message" do
            post :change_owner, :id => treatment_plan.id

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("error")
            expect(json["errors"]).to include('Treatment Plan Owner can not be switched')
            expect(treatment_plan.reload.creator).to eq(physician1)
          end
        end

        context "when the user who is not the part of patient careteam attempts to change the owner for the Orphaned treatment plan" do
          let!(:physician1) { FactoryGirl.create(:user_with_physician_role) }
          let!(:patient1) { FactoryGirl.create(:user) }
          let!(:patient1_careteam) { FactoryGirl.create(:careteam, :patient => patient1) }

          # This is a Unorphaned treatment plan as the "physician1" is not a part of patient1's careteam
          let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient1, :creator => physician1) }

          before do
            patient1_careteam.add_member(physician1)
          end

          it "should not change the owner and render an error message" do
            post :change_owner, :id => treatment_plan.id

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("error")
            expect(json["errors"]).to include('Treatment Plan Owner can not be switched')
            expect(treatment_plan.reload.creator).to eq(physician1)
          end
        end
      end
    end
  end

  describe '#remove_treatment_plan' do
    context "when the user is not logged in" do
      context "when the user attempts to remove a Treatment Plan" do
        it "should get an error message" do
          post :remove_treatment_plan, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "as patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient) }
        before do
          token_sign_in(patient)
        end

        it "should render an error message" do
          post :remove_treatment_plan, :id => treatment_plan.id

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

        context "when user attempts to remove an Orphaned treatment plan" do
          let!(:physician1) { FactoryGirl.create(:user_with_physician_role) }
          let!(:patient1) { FactoryGirl.create(:user) }
          let!(:patient1_careteam) { FactoryGirl.create(:careteam, :patient => patient1) }

          # This is a orphaned treatment plan as the "physician1" is not a part of patient1's careteam
          let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient1, :creator => physician1) }

          before do
            patient1_careteam.add_member(physician)
          end

          it "should remove the treatment plan" do
            post :remove_treatment_plan, :id => treatment_plan.id

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("success")
            expect(json['data']).to eq("Treatment Plan removed successfully")
          end
        end

        context "when user attempts to remove an Orphaned treatment plan but is not a member of the careteam" do
          let!(:physician1) { FactoryGirl.create(:user_with_physician_role) }
          let!(:patient1) { FactoryGirl.create(:user) }
          let!(:patient1_careteam) { FactoryGirl.create(:careteam, :patient => patient1) }

          # This is a orphaned treatment plan as the "physician1" is not a part of patient1's careteam
          let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient1, :creator => physician1) }

          it "should remove the treatment plan" do
            post :remove_treatment_plan, :id => treatment_plan.id

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("error")
            expect(json['errors']).to include("Treatment Plan can not be removed")
          end
        end

        context "when user attempts to remove an Un-Orphaned treatment plan" do
          let!(:physician1) { FactoryGirl.create(:user_with_physician_role) }
          let!(:patient1) { FactoryGirl.create(:user) }
          let!(:patient1_careteam) { FactoryGirl.create(:careteam, :patient => patient1) }

          # This is a orphaned treatment plan as the "physician1" is not a part of patient1's careteam
          let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient1, :creator => physician1) }

          before do
            patient1_careteam.add_member(physician1)
            patient1_careteam.add_member(physician)
          end

          it "should remove the treatment plan" do
            post :remove_treatment_plan, :id => treatment_plan.id

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("error")
            expect(json['errors']).to include("Treatment Plan can not be removed")
          end
        end
      end
    end
  end

end