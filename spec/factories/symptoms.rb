FactoryGirl.define do
  factory :symptom do
    sequence :name do | n |
      "SymptomName#{n}"
    end
  end

end
