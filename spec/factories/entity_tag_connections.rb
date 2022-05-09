FactoryGirl.define do
  factory :entity_tag_connection do
    taggable_entity_id 1
    taggable_entity_type "MyString"
    tag_id 1
  end
end
