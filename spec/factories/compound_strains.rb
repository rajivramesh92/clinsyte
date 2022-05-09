FactoryGirl.define do
  factory :compound_strain do
    compound { FactoryGirl.create(:compound) }
    strain { FactoryGirl.create(:strain) }
    high { rand(1..100) }
    low { rand(1..100) }
    average { rand(1..100) }
  end

end
