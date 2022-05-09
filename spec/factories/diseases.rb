FactoryGirl.define do
  factory :disease do
    condition { FactoryGirl.create(:condition) }
    patient { FactoryGirl.create(:user) }
    diagnosis_date "2016-03-31"
  end

end
