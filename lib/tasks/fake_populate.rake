namespace :db do
  desc "Erase and fill database with test data"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [User, Player, Organization, Game].each(&:delete_all)

    User.populate 100..200 do |user|
      user.email = Faker::Internet.email
      user.encrypted_password = '$2a$04$dhaleOrCGwRdtNVMsWJIF.tm/BuZlXHC1TENvKKn8oCSI9wquQ9qu' # password = 'password'
      user.sign_in_count = Faker::Number.digit
      user.last_sign_in_at = 2.months.ago..Time.now
      user.last_sign_in_ip = Faker::Internet.ip_v4_address
      user.created_at = 3.months.ago..user.last_sign_in_at
      user.updated_at = user.created_at..Time.now
      user.first_name = Faker::Name.first_name
      user.last_name = Faker::Name.last_name
      user.phone = Faker::PhoneNumber.phone_number
    end

    Organization.populate 3 do |organization|
      organization.name = Faker::Company.name
      organization.slug = Faker::Internet.slug
      organization.location = "#{Faker::Address.city}, #{Faker::Address.state_abbr}"
      organization.timezone = Faker::Address.time_zone
      organization.description = Faker::Lorem.paragraph
      organization.created_at = 4.months.ago..3.months.ago
      organization.updated_at = organization.created_at..Time.now

      Game.populate 1..2 do |game|
        game.name = Faker::Company.catch_phrase
        game.slug = Faker::Internet.slug
        game.organization_id = organization.id
        game.timezone = Faker::Address.time_zone
        game.registration_start = 1.weeks.ago..Time.now
        game.registration_end = Time.now..(Time.now + 1.week)
        game.game_start = game.registration_start..(game.registration_end + 1.week)
        game.game_end = game.game_start..(game.game_start + 1.week)
        game.description = Faker::Lorem.paragraph
        game.created_at = 2.weeks.ago..game.registration_start
        game.updated_at = game.created_at..Time.now

        users = User.all.sample(Random.new.rand 20..80)
        Player.populate users.count do |player|
          player.user_id = users.pop.id
          player.game_id = game.id
          player.created_at = game.created_at..Time.now
          player.updated_at = player.created_at..Time.now
        end
      end
    end
  end
end