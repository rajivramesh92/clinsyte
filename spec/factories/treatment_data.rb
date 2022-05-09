FactoryGirl.define do
  factory :treatment_datum do
    treatment_plan_therapy { FactoryGirl.create(:treatment_plan_therapy) }
    intake_count 1
    last_intake nil
    last_reminded nil
  end

end
