FactoryGirl.define do
  factory :tag_group do
    sequence :name do |n|
      "Tag Group #{n}"
    end
  end
end
