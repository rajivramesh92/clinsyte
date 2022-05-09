FactoryGirl.define do
  factory :notification do
    sender_id 1
    sender_type "MyString"
    recipient_id 1
    recipient_type "MyString"
    message "MyString"
    status "unseen"
    category "careteam_request_initiated"
  end
end
