FactoryGirl.define do
  factory :councillor do
    name 'MyString MyString'
    sequence(:username) { |i| "username#{i}" }
    password 'passwd321'
    association(:party)
  end
end
