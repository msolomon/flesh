require 'spec_helper'

describe "Tag API" do

  let(:tag_params) {Hash[:tag, Hash[:human_code, :hcode]].to_json}

  it 'cannot tag when anonymous' do
    post api_tags_path, tag_params
    expect(response.status).to eq(401)
  end

  it 'cannot tag without human code' do
    expect{post api_tags_path, "", user_auth_header(create_zombie.user)}.to raise_error(ActionController::ParameterMissing)
  end

  it 'cannot tag with invalid human code' do
    post api_tags_path, Hash[:tag, Hash[:human_code, :noway]].to_json, user_auth_header(create_zombie.user)
    expect(response.status).to eq(422)
  end

  it 'zombie can tag human' do
    game = FactoryGirl.create(:game)
    human = FactoryGirl.create(:player, game: game)
    zombie = FactoryGirl.create(:player, game: game, human_code: "zcode",
      user: FactoryGirl.create(:user, {email: "z@z.com", screen_name: "zombocom"})
    )
    FactoryGirl.create(:tag, {taggee: zombie})

    request_via_redirect :post, api_tags_path, tag_params, user_auth_header(zombie.user)
    expect(response.status).to eq(201)
  end

  it 'oz can tag human' do
    game = FactoryGirl.create(:game, {game_start: Time.now - 1.hour})
    human = FactoryGirl.create(:player, game: game)
    oz = FactoryGirl.create(:player, game: game, human_code: "zcode", oz_status: :confirmed,
      user: FactoryGirl.create(:user, {email: "z@z.com", screen_name: "zombocom"})
    )

    request_via_redirect :post, api_tags_path, tag_params, user_auth_header(oz.user)
    expect(response.status).to eq(201)
  end

  it 'stealthed oz is not revealed in tag' do
    game = FactoryGirl.create(:game, {game_start: Time.now - 1.hour})
    human = FactoryGirl.create(:player, game: game)
    oz = FactoryGirl.create(:player, game: game, human_code: "zcode", oz_status: :confirmed,
      user: FactoryGirl.create(:user, {email: "z@z.com", screen_name: "zombocom"})
    )

    request_via_redirect :post, api_tags_path, tag_params, user_auth_header(oz.user)
    expect(get_json['tag']['tagger_id']).to eq(0)
  end

  it 'revealed oz is revealed in tag' do
    game = FactoryGirl.create(:game, {game_start: Time.now - 1.hour, oz_reveal: Time.now - 1.minute})
    human = FactoryGirl.create(:player, game: game)
    oz = FactoryGirl.create(:player, game: game, human_code: "zcode", oz_status: :confirmed,
      user: FactoryGirl.create(:user, {email: "z@z.com", screen_name: "zombocom"})
    )

    request_via_redirect :post, api_tags_path, tag_params, user_auth_header(oz.user)
    expect(get_json['tag']['tagger_id']).to eq(oz.id)
  end

  it 'zombie cannot tag itself' do
    game = FactoryGirl.create(:game)
    zombie = FactoryGirl.create(:player, game: game, human_code: "hcode",
      user: FactoryGirl.create(:user, {email: "z@z.com", screen_name: "zombocom"})
    )
    FactoryGirl.create(:tag, {taggee: zombie})

    request_via_redirect :post, api_tags_path, tag_params, user_auth_header(zombie.user)
    expect(response.status).to eq(422)
  end

  it 'starved zombie cannot tag human' do
    game = FactoryGirl.create(:game)
    human = FactoryGirl.create(:player, game: game)
    zombie = FactoryGirl.create(:player, game: game, human_code: "zcode",
      user: FactoryGirl.create(:user, {email: "z@z.com", screen_name: "zombocom"})
    )
    FactoryGirl.create(:tag, {taggee: zombie, claimed: 2.days.ago})

    request_via_redirect :post, api_tags_path, tag_params, user_auth_header(zombie.user)
    expect(response.status).to eq(422)
  end

  it 'starved oz cannot tag human' do
    game = FactoryGirl.create(:game, {game_start: Time.now - 2.days})
    human = FactoryGirl.create(:player, game: game)
    oz = FactoryGirl.create(:player, game: game, human_code: "zcode", oz_status: :confirmed,
      user: FactoryGirl.create(:user, {email: "z@z.com", screen_name: "zombocom"})
    )

    request_via_redirect :post, api_tags_path, tag_params, user_auth_header(oz.user)
    expect(response.status).to eq(422)
  end

  it 'zombie cannot tag human in another game' do
    organization = FactoryGirl.create(:organization)
    game1 = FactoryGirl.create(:game, organization: organization)
    game2 = FactoryGirl.create(:game, {organization: organization, name: "2", slug: "2"})
    human = FactoryGirl.create(:player, game: game2)
    zombie = FactoryGirl.create(:player, game: game1, human_code: "zcode",
      user: FactoryGirl.create(:user, {email: "z@z.com", screen_name: "zombocom"})
    )
    FactoryGirl.create(:tag, {taggee: zombie})

    request_via_redirect :post, api_tags_path, tag_params, user_auth_header(zombie.user)
    expect(response.status).to eq(422)
  end

  it 'cannot tag in past game' do
    game = FactoryGirl.create(:game, {
      game_start: 3.minutes.ago,
      game_end: 1.minute.ago,
      registration_start: 5.minutes.ago,
      registration_end: 2.minutes.ago,
      oz_reveal: 2.minutes.ago
    })
    human = FactoryGirl.create(:player, game: game)
    zombie = FactoryGirl.create(:player, game: game, human_code: "zcode",
      user: FactoryGirl.create(:user, {email: "z@z.com", screen_name: "zombocom"})
    )
    FactoryGirl.create(:tag, {taggee: zombie})

    request_via_redirect :post, api_tags_path, tag_params, user_auth_header(zombie.user)
    expect(response.status).to eq(422)
  end

  it 'cannot tag in future game' do
    game = FactoryGirl.create(:game, {
      game_start: 1.minute.from_now,
      game_end: 3.minutes.from_now,
      registration_start: 2.minutes.ago,
      registration_end: Time.now,
      oz_reveal: 2.minutes.from_now
    })
    human = FactoryGirl.create(:player, game: game)
    zombie = FactoryGirl.create(:player, game: game, human_code: "zcode",
      user: FactoryGirl.create(:user, {email: "z@z.com", screen_name: "zombocom"})
    )
    FactoryGirl.create(:tag, {taggee: zombie})

    request_via_redirect :post, api_tags_path, tag_params, user_auth_header(zombie.user)
    expect(response.status).to eq(422)
  end

end
