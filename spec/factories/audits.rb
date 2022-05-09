FactoryGirl.define do
  factory :audit do
    auditable { FactoryGirl.create(:disease) }
    user { FactoryGirl.create(:user) }
    associated { FactoryGirl.create(:user) }
    action { [ 'create', 'update', 'destroy' ].sample }
    audited_changes {}
    version 1
  end
end
