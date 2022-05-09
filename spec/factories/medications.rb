FactoryGirl.define do
  factory :medication do
    sequence :name do | n |
      "MedicationName#{n}"
    end
    description "MyText"
  end

end
