FactoryGirl.define do
  factory :session_item do
    association :author, factory: :councillor
    title 'MyString'
    acceptance 0
  end
end
