require 'spec_helper'

describe "Player model" do

  it 'marks oz' do
    player = FactoryGirl.create(:player, {oz_status: :confirmed, game: FactoryGirl.create(:game, {game_start: Time.now - 5.hours})})

    expect(player.true_status).to eq(:oz)
    expect(player.canTag?).to eq(true)
    expect(player.canBeTagged?).to eq(false)
  end

  it 'marks oz when starved' do
    player = FactoryGirl.create(:player, {oz_status: :confirmed, game: FactoryGirl.create(:game, {game_start: Time.now - 2.days})})

    expect(player.true_status).to eq(:starved)
    expect(player.canTag?).to eq(false)
    expect(player.canBeTagged?).to eq(false)
  end

  it 'marks zombie' do
    player = FactoryGirl.create(:player)
    tag = FactoryGirl.create(:tag, {taggee: player})

    expect(player.true_status).to eq(:zombie)
    expect(player.canTag?).to eq(true)
    expect(player.canBeTagged?).to eq(false)
  end

  it 'marks zombie when starved' do
    player = FactoryGirl.create(:player)
    tag = FactoryGirl.create(:tag, {taggee: player, claimed: 36.hours.ago})

    expect(player.true_status).to eq(:starved)
    expect(player.canTag?).to eq(false)
    expect(player.canBeTagged?).to eq(false)
  end

  it 'marks human' do
    player = FactoryGirl.create(:player)

    expect(player.true_status).to eq(:human)
    expect(player.canTag?).to eq(false)
    expect(player.canBeTagged?).to eq(true)
  end

  it 'records join game events on create' do
    user = FactoryGirl.create(:user)
    organization = FactoryGirl.create(:organization)
    game = FactoryGirl.create(:game, organization: organization)

    user_events_count = user.events.count
    organization_events_count = organization.events.count
    game_events_count = game.events.count

    player = FactoryGirl.create(:player, user: user, game: game)

    expect(player.user.events.count).to eq(user_events_count + 1)
    expect(player.game.events.count).to eq(game_events_count + 1)
    expect(player.game.organization.events.count).to eq(organization_events_count + 1)
    expect(player.events.count).to eq(1)
  end

end
