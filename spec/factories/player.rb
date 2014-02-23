FactoryGirl.define do
  
  factory :player do
    user
    game
    created_at Time.now
    updated_at Time.now
    human_code "hcode"
    oz_status :uninterested
  end

end
