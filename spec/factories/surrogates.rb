FactoryGirl.define do
  factory :surrogate do
    name 'MyString'
    voter_registration { 12.times.map { rand(10) }.join('') }
  end
end
