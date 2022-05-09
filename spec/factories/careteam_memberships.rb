FactoryGirl.define do
  factory :careteam_membership do
    careteam { FactoryGirl.create(:careteam) }
    member nil
    level 0
  end

end
