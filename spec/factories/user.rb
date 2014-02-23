require 'faker'

FactoryGirl.define do
  factory :user do
    email "First@example.com"
    password "password"
    first_name "Bill"
    last_name "Nye"
    screen_name "science guy"
    authentication_token "testtoken"
  end

end
