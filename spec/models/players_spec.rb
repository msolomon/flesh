require 'spec_helper'

describe "Player model" do

  def create_user
    user
  end

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

end
