FactoryGirl.define do
  factory :councillors_queue do
    association(:plenary_session)
    councillors_ids []
  end
end
