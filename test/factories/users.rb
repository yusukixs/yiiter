FactoryGirl.define do
  factory :user do
    sequence(:account_name) { |n| "Taro#{n}" }
    full_name "Yamada Taro"
    sequence(:email) { |n| "taro#{n}@example.com" }
    password "password"
    password_confirmation "password"
  end
end