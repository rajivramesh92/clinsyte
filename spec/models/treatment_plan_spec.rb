require 'rails_helper'

RSpec.describe TreatmentPlan, type: :model do

  # Assosiations
  it { is_expected.to belong_to(:patient).class_name(:User) }
  it { is_expected.to have_many(:therapies).class_name(TreatmentPlanTherapy) }

  # Nested attributes
  describe "Nested Attributes for " do
    it "should accept nested attributes for therapies" do
      expect do
        FactoryGirl.create(:treatment_plan_therapy, :dosage_frequencies_attributes => [{ :name => "n times a day", :value => 2 }])
      end
      .to change(TreatmentPlanTherapy, :count).by(1)
    end
  end
end
