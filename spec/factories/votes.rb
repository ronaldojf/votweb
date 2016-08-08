FactoryGirl.define do
  factory :vote do
    association(:project)
    association(:councillor)
    association(:plenary_session)
  end
end
