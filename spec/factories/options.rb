FactoryGirl.define do
  factory :option do
    sequence :name do |n|
      "Option#{n}"
    end
    list { FactoryGirl.create(:list) }
  end
end
