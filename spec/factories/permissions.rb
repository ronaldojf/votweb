FactoryGirl.define do
  factory :permission do
    sequence(:subject) { |i| "MyString_#{i}"}
    actions ['read', 'create', 'update', 'destroy']
    role nil
  end
end
