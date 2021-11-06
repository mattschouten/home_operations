FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test_user_#{n}@example.com" }
    password { 'sssh this is secret' }
  end
end
