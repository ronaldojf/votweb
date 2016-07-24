FactoryGirl.define do
  factory :administrator do
    name 'MyString'
    sequence(:email) { |i| "email#{i}@eamil.com" }
    password 'password123'
  end
end
