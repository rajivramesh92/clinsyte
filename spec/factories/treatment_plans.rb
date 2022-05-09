FactoryGirl.define do
  factory :treatment_plan do
    patient { FactoryGirl.create(:user) }
    title "Treatment Plan 1"
    creator { FactoryGirl.create(:user_with_physician_role) }
  end
end
