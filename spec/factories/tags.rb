FactoryGirl.define do
  factory :tag do
    sequence :name do |n|
      "Tag #{n}"
    end
    tag_group { FactoryGirl.create(:tag_group) }
  end

end
