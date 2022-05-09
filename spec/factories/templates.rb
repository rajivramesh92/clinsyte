FactoryGirl.define do
  factory :template do
    strain { FactoryGirl.create(:strain) }
    creator { FactoryGirl.create(:user_with_physician_role) }
    sequence :name do |n|
      "Template#{n}"
    end
    access_level 0
  end

end
