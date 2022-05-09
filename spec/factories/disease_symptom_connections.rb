FactoryGirl.define do
  factory :disease_symptom_connection do
    disease { FactoryGirl.create(:disease) }
    symptom { FactoryGirl.create(:symptom) }
  end

end
