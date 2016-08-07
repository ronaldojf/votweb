include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :party do
    name 'MyString MyString'
    sequence(:abbreviation) { |i| "MyString#{i}" }
    logo File.open(Rails.root.join('spec', 'photos', 'test.png'))
  end
end
