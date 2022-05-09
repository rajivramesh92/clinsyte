FactoryGirl.define do

  factory :survey_configuration do
    survey { FactoryGirl.create(:survey) }
    from_date Date.current
    days 7
    sender { FactoryGirl.create(:user_with_physician_role) }
    schedule_time '8:00:00'
    last_acknowledged nil
  end

end
