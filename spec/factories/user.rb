require 'faker'

FactoryGirl.define do
  factory :user do
    email "test@example.com"
    password "password"
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    screen_name { Faker::Internet.user_name }
  end
end
