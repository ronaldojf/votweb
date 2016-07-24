FactoryGirl.define do
  factory :role do
    sequence(:description) { |i| "MyString_#{i}" }
  end
end
