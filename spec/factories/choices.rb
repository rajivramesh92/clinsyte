FactoryGirl.define do
  factory :choice do
    question { FactoryGirl.create(:question) }
    sequence :option do | n |
      "Option#{n}"
    end
  end

end
