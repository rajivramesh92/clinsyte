FactoryGirl.define do
  factory :slot do
    physician { FactoryGirl.create(:user_with_physician_role) }
    from_time 3600.0
    to_time 7200.0
    day 0
    type "AvailableSlot"
    date { Date.today }
  end

end
