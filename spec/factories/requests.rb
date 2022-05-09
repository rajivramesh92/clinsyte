FactoryGirl.define do
  factory :request do
    sender { FactoryGirl.create(:user) }
    recipient { FactoryGirl.create(:user_with_physician_role) }
    status 0
  end
end
