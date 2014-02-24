require 'spec_helper'

describe "Game model" do

  it 'identifies running game' do
    game = FactoryGirl.create(:game, {
      game_start: 1.minute.ago,
      game_end: 1.minute.from_now,
      registration_start: 2.minutes.ago,
      registration_end: Time.now,
      oz_reveal: Time.now
    })

    expect(game.running?).to eq(true)
    expect(game.running_error_string).to be(nil)
  end

  it 'identifies future game' do
    game = FactoryGirl.create(:game, {
      game_start: 1.minute.from_now,
      game_end: 3.minutes.from_now,
      registration_start: 2.minutes.ago,
      registration_end: Time.now,
      oz_reveal: 2.minutes.from_now
    })

    expect(game.running?).to eq(false)
    expect(game.running_error_string).to match(/not yet begun/)
  end

  it 'identifies past game' do
    game = FactoryGirl.create(:game, {
      game_start: 3.minutes.ago,
      game_end: 1.minute.ago,
      registration_start: 5.minutes.ago,
      registration_end: 2.minutes.ago,
      oz_reveal: 2.minutes.ago
    })

    expect(game.running?).to eq(false)
    expect(game.running_error_string).to match(/already ended/)
  end

  it 'identifies open registration' do
    game = FactoryGirl.create(:game, {
      game_start: 1.minute.from_now,
      game_end: 3.minutes.from_now,
      registration_start: 2.minutes.ago,
      registration_end: 1.minute.from_now,
      oz_reveal: 2.minutes.from_now
    })

    expect(game.registration_open?).to eq(true)
    expect(game.registration_open_error_string).to be(nil)
  end

  it 'identifies future registration' do
    game = FactoryGirl.create(:game, {
      game_start: 10.minute.from_now,
      game_end: 30.minutes.from_now,
      registration_start: 1.minute.from_now,
      registration_end: 2.minutes.from_now,
      oz_reveal: 20.minutes.from_now
    })

    expect(game.registration_open?).to eq(false)
    expect(game.registration_open_error_string).to match(/not yet begun/)
  end

  it 'identifies past registration' do
    game = FactoryGirl.create(:game, {
      game_start: 1.minute.from_now,
      game_end: 3.minutes.from_now,
      registration_start: 2.minutes.ago,
      registration_end: 1.minute.ago,
      oz_reveal: 2.minutes.from_now
    })

    expect(game.registration_open?).to eq(false)
    expect(game.registration_open_error_string).to match(/already ended/)
  end

end