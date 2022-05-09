FactoryGirl.define do
  factory :answer do
    question { FactoryGirl.create(:question) }
    creator { FactoryGirl.create(:user) }
    request { FactoryGirl.create(:user_survey_form) }
    sequence :description do |n|
      "Answer#{n}"
    end
    choice_id nil
    value nil
  end

end
