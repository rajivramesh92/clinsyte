FactoryGirl.define do
  factory :category do
    sequence :name do | n |
      "MyString #{n}#{n*rand().to_i}"
    end
  end

end
