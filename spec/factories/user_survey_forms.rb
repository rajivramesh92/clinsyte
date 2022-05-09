FactoryGirl.define do
  factory :user_survey_form do
    survey { FactoryGirl.create(:survey) }
    state "pending"
    sender { FactoryGirl.create(:user_with_physician_role) }
    receiver { FactoryGirl.create(:user) }
    sent_at nil
    started_at nil
    submitted_at nil
  end

end
