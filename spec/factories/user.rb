require 'faker'

FactoryGirl.define do
  factory :user do
    email "first@example.com"
    password "password"
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    screen_name { Faker::Internet.user_name }
  end

  factory :second_user do
    email "second@example.com"
    password "password"
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    screen_name { Faker::Internet.user_name }
  end

end
