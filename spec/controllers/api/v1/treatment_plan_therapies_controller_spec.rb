describe Api::V1::TreatmentPlanTherapiesController do

  describe '#take' do
    context "when the user is not logged in" do
      context "when the user tries to take a therapy for Treatment Plan" do
        it "should get an error message" do
          post :take, :treatment_plan_id => 1, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "as physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        let!(:treatment_plan) { FactoryGirl.create(:treatment_plan) }
        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan) }
        before do
          token_sign_in(physician)
        end

        it "should render an error message" do
          post :take, :treatment_plan_id => treatment_plan.id, :id => treatment_plan_therapy.id

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        before do
          token_sign_in(patient)
        end

        context "when the user attempts to take a therapy for the Treatment Plan for the first time in the day" do
          let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient) }
          let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan) }
          let!(:dosage_frequencies1) { treatment_plan_therapy.dosage_frequencies.create(:name => 'n times a day', :value => 3) }
          let!(:dosage_frequencies2) { treatment_plan_therapy.dosage_frequencies.create(:name => 'every n hours', :value => 4) }

          let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
          let!(:careteam) { FactoryGirl.create(:careteam, :patient => patient) }

          let!(:survey) { FactoryGirl.create(:survey, :creator => physician) }
          let!(:event_dependent_survey) { FactoryGirl.create(:event_dependent_survey, :physician => physician) }

          before do
            careteam.add_member(physician)
            Audit.first.update(:user_id => physician.id, :user_type => "User")
            event_dependent_survey.receipients.create(:receiver_id => patient.id)
          end

          it "should create the Treatment Data assosiated with the Treatment Plan" do
            expect(EventDependentSurveySender).to receive(:perform_in).once

            post :take, :treatment_plan_id => treatment_plan.id, :id => treatment_plan_therapy.id

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("success")
            expect(json["data"]).to eq("Dosage taken successfully")
            expect(treatment_plan_therapy.treatment_data.last.intake_count).to eq(1)
            expect(treatment_plan_therapy.treatment_data.last.last_intake.utc.to_i).to eq(DateTime.now.to_i)
          end
        end

        context "when the user attempts to take a therapy from the Treatment Plan when treatment data has been created" do
          let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient) }
          let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan) }
          let!(:dosage_frequencies) { treatment_plan_therapy.dosage_frequencies.create(:name => 'as needed', :value => nil) }
          before do
            treatment_plan_therapy.take_therapy
          end

          it "should update the pre created treatment_data" do
            post :take, :treatment_plan_id => treatment_plan.id, :id => treatment_plan_therapy.id

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("success")
            expect(json["data"]).to eq("Dosage taken successfully")
            expect(treatment_plan_therapy.treatment_data.last.intake_count).to eq(2)
            expect(treatment_plan_therapy.treatment_data.last.last_intake.utc.to_i).to eq(DateTime.now.to_i)
          end
        end

        context "when the user attempts to take a therapy with overdose" do
          let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient) }
          let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan) }
          let!(:dosage_frequencies1) { treatment_plan_therapy.dosage_frequencies.create(:name => 'n times a day', :value => 2) }
          let!(:dosage_frequencies2) { treatment_plan_therapy.dosage_frequencies.create(:name => 'every n hours', :value => 4) }
          let!(:treatment_data) { treatment_plan_therapy.treatment_data.create(:intake_count => 2, :last_intake => Time.zone.now, :last_reminded => nil) }

          it "should update the Dosage Data and return a warning of Overdosage" do
            post :take, :treatment_plan_id => treatment_plan.id, :id => treatment_plan_therapy.id

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("error")
            expect(json["errors"]).to include("This dosage is an overdose as per prescription")
            expect(treatment_plan_therapy.treatment_data.last.intake_count).to eq(3)
            expect(treatment_plan_therapy.treatment_data.last.last_intake.utc.to_i).to eq(DateTime.now.to_i)
          end
        end
      end
    end

  end

  describe "#snooze" do
    context "when the user is not logged in" do
      context "when the user tries to snooze a therapy" do
        it "should get an error message" do
          post :snooze, :treatment_plan_id => 1, :id => 1

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Authorized users only.")
        end
      end
    end

    context "when the user is logged in" do
      context "as physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        let!(:treatment_plan) { FactoryGirl.create(:treatment_plan) }
        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan) }
        before do
          token_sign_in(physician)
        end

        it "should render an error message" do
          post :snooze, :treatment_plan_id => treatment_plan.id, :id => treatment_plan_therapy.id

          expect_unauthorized_access
          expect_json_content
          expect(json['errors']).to include("Unauthorized access")
        end
      end

      context "as patient" do
        let!(:patient) { FactoryGirl.create(:user) }
        let!(:treatment_plan) { FactoryGirl.create(:treatment_plan, :patient => patient) }
        let!(:treatment_plan_therapy) { FactoryGirl.create(:treatment_plan_therapy, :treatment_plan => treatment_plan) }
        before do
          token_sign_in(patient)
        end

        context "when the user attempts to snooze a therapy when he has not prompted" do
          let!(:dosage_frequencies1) { treatment_plan_therapy.dosage_frequencies.create(:name => 'n times a day', :value => 3) }
          let!(:dosage_frequencies2) { treatment_plan_therapy.dosage_frequencies.create(:name => 'every n hours', :value => 4) }

          it "should render error stating Reminder can't be snoozed" do
            post :snooze, :treatment_plan_id => treatment_plan.id, :id => treatment_plan_therapy.id

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("error")
            expect(json["errors"]).to include("Therapy Reminder snoozing unsuccessfull")
          end
        end

        context "when the patient attempts to snooze the therapy" do
          let!(:dosage_frequencies1) { treatment_plan_therapy.dosage_frequencies.create(:name => 'n times a day', :value => 3) }
          let!(:dosage_frequencies2) { treatment_plan_therapy.dosage_frequencies.create(:name => 'every n hours', :value => 4) }
          let!(:treatment_data) { treatment_plan_therapy.treatment_data.create(:intake_count => 2, :last_intake => Time.zone.now) }

          it "should snooze the therapy for the configured time" do
            expect(ReminderSenderWorker).to receive(:perform_in).once

            post :snooze, :treatment_plan_id => treatment_plan.id, :id => treatment_plan_therapy.id

            expect_success_status
            expect_json_content
            expect(json["status"]).to eq("success")
            expect(json["data"]).to eq("Therapy Reminder snoozed successfully")
          end
        end
      end

    end
  end

end