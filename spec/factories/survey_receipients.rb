FactoryGirl.define do

  factory :survey_receipient do
    survey { FactoryGirl.create(:survey_configuration) }
    receiver_id nil
  end

end
