FactoryGirl.define do
  factory :appointment do
    physician { FactoryGirl.create(:user_with_physician_role) }
    patient { FactoryGirl.create(:user) }
    date '2016-04-16'
    from_time 2000.0
    to_time 3000.0
    status 0
  end

end
