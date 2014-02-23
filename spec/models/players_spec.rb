require 'spec_helper'

describe "Player model" do

  def create_user
    user
  end

  it 'marks oz' do
    player = FactoryGirl.create(:player, {oz_status: :confirmed, game: FactoryGirl.create(:game, {game_start: Time.now - 5.hours})})

    expect(player.true_status).to eq(:oz)
  end

  # it 'marks oz when starved' do
  #   player = FactoryGirl.create(:player, {oz_status: :confirmed, game: FactoryGirl.create(:game, {game_start: Time.now - 2.days})})

  #   expect(player.true_status).to eq(:starved)
  # end

  it 'marks zombie' do
    player = FactoryGirl.create(:player)
    tag = FactoryGirl.create(:tag, {taggee: player})

    expect(player.true_status).to eq(:zombie)
  end

end