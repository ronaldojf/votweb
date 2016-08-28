FactoryGirl.define do
  factory :vote do
    association(:poll)
    kind 0

    trait :with_councillor do
      association(:councillor)
    end
  end
end
