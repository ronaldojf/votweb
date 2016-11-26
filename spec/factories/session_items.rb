FactoryGirl.define do
  factory :session_item do
    association :author, factory: :councillor
    title 'MyString'
    abstract 'MyString MyString MyString'
    acceptance 0
  end
end
