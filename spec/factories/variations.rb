FactoryGirl.define do
  factory :variation do
    sequence :name do | n | 
      "myString#{n}"
    end
    chromosome "MyString"
    position 1
    genotype "MyString"
    maf "MyString"
    genetic_id 1
  end

end
