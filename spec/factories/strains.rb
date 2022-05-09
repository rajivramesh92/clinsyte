FactoryGirl.define do
  factory :strain do
    sequence :name do | n |
      "TherapyName#{n}"
    end

    sequence :brand_name do | n |
      "brand_name#{n}"
    end

    category { FactoryGirl.create(:category) }
  end

end
