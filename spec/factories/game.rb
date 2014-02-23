FactoryGirl.define do

  factory :game do
    name "winter game"
    slug "winter"
    organization
    timezone "US/Pacific"
    registration_start Time.now - 2.weeks
    registration_end Time.now + 1.day
    game_start Time.now - 2.days
    game_end Time.now + 2.days
    description "A bomb game"
    options starve_time: 1.day
  end

end
