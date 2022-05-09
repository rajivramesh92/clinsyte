FactoryGirl.define do
  factory :template_datum do
    message "Message for Template"
    template { FactoryGirl.create(:template) }
  end

end
