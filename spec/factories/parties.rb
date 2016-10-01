FactoryGirl.define do
  factory :party do
    name 'MyString MyString'
    sequence(:abbreviation) { |i| "MyString#{i}" }
  end
end
