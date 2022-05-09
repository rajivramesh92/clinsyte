FactoryGirl.define do
  factory :genetic do
    sequence :name do | n |
      "genetic#{n}"
    end
    patient { FactoryGirl.create(:user) }
  end

end
