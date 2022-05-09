FactoryGirl.define do
  factory :careteam do
    patient { FactoryGirl.create(:user) }
  end

end
