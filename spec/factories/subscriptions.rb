FactoryGirl.define do
  factory :subscription do
    association(:plenary_session)
    association(:councillor)
  end
end
