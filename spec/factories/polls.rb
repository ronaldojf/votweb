FactoryGirl.define do
  factory :poll do
    process 0
    association(:plenary_session)
    description 'MyString'
    duration 15

    trait :with_session_item do
      association(:session_item)
    end
  end
end
