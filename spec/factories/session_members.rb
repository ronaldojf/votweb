FactoryGirl.define do
  factory :session_member do
    association(:plenary_session)
    association(:councillor)
    is_president false
  end
end
