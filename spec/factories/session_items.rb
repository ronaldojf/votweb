FactoryGirl.define do
  factory :session_item do
    title 'MyString'
    abstract 'MyString MyString MyString'
    acceptance 0

    trait :with_author do
      association :author, factory: :councillor
    end
  end
end
