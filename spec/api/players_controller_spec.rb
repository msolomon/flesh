require 'spec_helper'

describe "Player API" do
  let(:create_user) {FactoryGirl.create(:user)}

  def join_params game_id, oz_pool
    Hash[:player, Hash[:game_id, game_id, :oz_pool, oz_pool]].to_json
  end

  it 'joins game' do
    game = FactoryGirl.create(:game)
    user = create_user

    post api_players_path, join_params(game.id, false), user_auth_header(user) 
    expect(response.status).to eq(201)
    player_json = get_json['player']
    expect(player_json['user_id']).to eq(user.id)






    # TODO: display OZ interest to current users
    # TODO: check results more carefully 
    # TODO: can't join closed-for-rgeistration game





  end

  it 'can join game without oz_pool' do
    game = FactoryGirl.create(:game)
    user = create_user

    post api_players_path, Hash[:player, Hash[:game_id, game.id]].to_json, user_auth_header(user) 
    expect(response.status).to eq(201)
    player_json = get_json['player']
    expect(player_json['user_id']).to eq(user.id)
  end

  it 'oz_pool uninterested status works for current user' do
    user = create_user
    player = FactoryGirl.create(:player, {user: user, oz_status: :uninterested})

    get api_player_path(player.id), nil, user_auth_header(user) 
    expect(response.status).to eq(200)
    expect(get_json['player']['oz_status']).to eq('uninterested')
    player_json = get_json['player']
  end

  it 'oz_pool unconfirmed status works for current user' do
    user = create_user
    player = FactoryGirl.create(:player, {user: user, oz_status: :unconfirmed})

    get api_player_path(player.id), nil, user_auth_header(user) 
    expect(response.status).to eq(200)
    expect(get_json['player']['oz_status']).to eq('unconfirmed')
  end

  it 'oz_pool nil for other users' do
    user = create_user
    user2 = FactoryGirl.create(:user, {email: "2@2.com", screen_name: "num2"})
    player = FactoryGirl.create(:player, {user: user, oz_status: :unconfirmed})

    get api_player_path(player.id), nil, user_auth_header(user2) 
    expect(response.status).to eq(200)
    expect(get_json['player']['oz_status']).to eq(nil)
  end

  it 'oz_pool nil for anonymous' do
    user = create_user
    player = FactoryGirl.create(:player, {user: user, oz_status: :unconfirmed})

    get api_player_path(player.id)
    expect(response.status).to eq(200)
    expect(get_json['player']['oz_status']).to eq(nil)
  end

  it 'shows human stauses correctly' do
    expect_statuses(create_human, :human, :human)
  end

  it 'shows zombie stauses correctly' do
    expect_statuses(create_zombie, :zombie, :zombie)
  end

  it 'shows starved zombie stauses correctly' do
    expect_statuses(create_starved_zombie, :starved, :starved)
  end

  it 'shows oz stauses correctly before reveal time' do
    oz = create_oz
    oz.game.oz_reveal = Time.now + 1.minute
    oz.game.save!

    expect_statuses(oz, :zombie, :human)
  end

  it 'shows oz stauses correctly after reveal time' do
    oz = create_oz
    oz.game.oz_reveal = Time.now - 1.minute
    oz.game.save!

    expect_statuses(oz, :zombie, :zombie)
  end

  it 'shows starved oz stauses correctly' do
    expect_statuses(create_starved_oz, :starved, :starved)
  end

  def expect_statuses(player, expected_me, expected_another)
    get api_player_path(player), nil, user_auth_header(player.user)
    expect(response.status).to eq(200)
    expect(player_status).to eq(expected_me)
    last_fed_nil_if_appropriate expected_me

    another = FactoryGirl.create(:user, {email: '2@gmail.COM', screen_name: 'skeletor'})
    get api_player_path(player), nil, user_auth_header(another)
    expect(response.status).to eq(200)
    expect(player_status).to eq(expected_another)
    last_fed_nil_if_appropriate expected_another

    # also check anonymously
    get api_player_path(player)
    expect(response.status).to eq(200)
    expect(player_status).to eq(expected_another)
    last_fed_nil_if_appropriate expected_another
  end

  def player_status
    JSON.parse(response.body)['player']['status'].to_sym
  end

  def last_fed_nil_if_appropriate expected_status
    last_fed = JSON.parse(response.body)['player']['last_fed']
    if expected_status == :zombie
      expect(last_fed).not_to eq(nil)
    else
      expect(last_fed).to eq(nil)
    end
  end

end
