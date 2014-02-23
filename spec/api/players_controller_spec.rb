require 'spec_helper'

describe "Player API" do

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
