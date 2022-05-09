FactoryGirl.define do
  factory :user do
    first_name "Test"
    last_name "User"
    gender "Male"
    ethnicity "ethnicity"
    birthdate { 25.years.ago.to_date }
    password "please123"
    country_code { '91' }
    phone_number { 10.times.map { rand(10) }.join("") }
    location "bangalore"
    preferred_device "android"
    time_zone "Central Time (US & Canada)"

    sequence :email do | n |
      "test#{n}#{n+1}@example.com"
    end

    factory :user_with_admin_role do
      privilege User.privileges[:admin]
    end

    factory :user_with_physician_role do
      role Role.physician rescue nil
    end

    factory :user_with_counselor_role do
      role Role.counselor rescue nil
    end

    factory :user_with_support_role do
      role Role.support rescue nil
    end
  end
end
