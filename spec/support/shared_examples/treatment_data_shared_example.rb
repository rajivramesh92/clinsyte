module TreatmentDataSharedExample

  shared_examples_for "overdosage?" do
    context "when the entity passed is 'overdosage'" do
      context "when overdose has not been taken" do
        let!(:treatment_data) { FactoryGirl.create(:treatment_datum, :treatment_plan_therapy => treatment_plan_therapy, :intake_count => 2) }

        it "should return false stating 'No overdose has been taken yet'" do
          expect(treatment_data.overdosage?).to be(false)
        end
      end

      context "when overdose has been taken" do
        let!(:treatment_data) { FactoryGirl.create(:treatment_datum, :treatment_plan_therapy => treatment_plan_therapy, :intake_count => 3) }

        it "should return true stating 'Overdose has been taken'" do
          expect(treatment_data.overdosage?).to be(true)
        end
      end
    end
  end

  shared_examples_for "remindable?" do
    context "when the entity passed is 'reminder'" do
      context "when reminder needs to be set for the next dosage" do
        let!(:treatment_data) { FactoryGirl.create(:treatment_datum, :treatment_plan_therapy => treatment_plan_therapy, :intake_count => 1) }

        it "should return true stating 'Reminder needs to be set'" do
          expect(treatment_data.remindable?).to be(true)
        end
      end

      context "when reminder needs not to be set for the next dosage" do
        let!(:treatment_data) { FactoryGirl.create(:treatment_datum, :treatment_plan_therapy => treatment_plan_therapy, :intake_count => 2) }

        it "should return false stating 'Reminder needs not to be set'" do
          expect(treatment_data.remindable?).to be(false)
        end
      end
    end
  end

end