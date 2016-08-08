FactoryGirl.define do
  factory :project do
    association :author, factory: :councillor
    title 'MyString'
  end
end
