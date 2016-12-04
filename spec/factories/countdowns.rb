FactoryGirl.define do
  factory :countdown do
    association(:plenary_session)
    description 'MyString'
    duration 15
  end
end
