FactoryGirl.define do
  factory :condition do
    sequence :name do | n |
      "ConditionName#{n}"
    end
  end

end
