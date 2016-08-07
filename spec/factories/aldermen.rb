include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :alderman do
    name 'MyString MyString'
    voter_registration { 12.times.map { rand(10) }.join('') }
    association(:party)
    avatar File.open(Rails.root.join('spec', 'photos', 'test.png'))
  end
end
