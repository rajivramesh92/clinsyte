FactoryGirl.define do
  factory :event_dependent_survey do
    survey { FactoryGirl.create(:survey) }
    physician { FactoryGirl.create(:user_with_physician_role) }
    time 50
  end

end
