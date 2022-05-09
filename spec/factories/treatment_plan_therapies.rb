FactoryGirl.define do
  factory :treatment_plan_therapy do
    treatment_plan { FactoryGirl.create(:treatment_plan) }
    strain { FactoryGirl.create(:strain) }
    dosage_quantity { rand(1.0..100.0).round }
    dosage_unit "mg"
    message "Take Therapy regularly without break for better results"
    intake_timing 0
  end
end
