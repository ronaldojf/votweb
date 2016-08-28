FactoryGirl.define do
  factory :vote do
    association(:session_item)
    association(:councillor)
    association(:plenary_session)
  end
end
