FactoryGirl.define do
  factory :councillors_queue do
    association(:plenary_session)
    duration 20
    councillors_ids []
  end
end
