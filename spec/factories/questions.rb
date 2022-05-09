FactoryGirl.define do
  factory :question do
    sequence :description do | n |
      "Question#{n}"
    end
    survey { FactoryGirl.create(:survey) }
    status 0
    type "DescriptiveQuestion"
    category nil
    min_range nil
    max_range nil
    list_id nil
  end
end
