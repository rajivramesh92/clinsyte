FactoryGirl.define do
  factory :disease_medication_connection do
    disease { FactoryGirl.create(:disease) }
    medication { FactoryGirl.create(:medication) }
  end

end
