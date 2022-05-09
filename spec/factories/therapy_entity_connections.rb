FactoryGirl.define do
  factory :therapy_entity_connection do
    treatment_plan_therapy { FactoryGirl.create(:treatment_plan_therapy) }
    associated_entity { FactoryGirl.create(:symptom) }
  end
end
