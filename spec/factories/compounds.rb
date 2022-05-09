FactoryGirl.define do
  factory :compound do
    sequence :name do |n|
      "Compound #{n}"
    end
  end
end
