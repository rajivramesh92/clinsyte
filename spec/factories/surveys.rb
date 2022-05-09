FactoryGirl.define do
  factory :survey do
    sequence :name do | n |
      "Survey#{n}"
    end
    creator { FactoryGirl.create(:user_with_physician_role) }
    treatment_plan_dependent false
  end
end
