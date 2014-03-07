require 'spec_helper'

describe "Tag model" do

  it 'records tag event on create' do
    organization = FactoryGirl.create(:organization)
    game = FactoryGirl.create(:game, organization: organization)
    tagger_user = FactoryGirl.create(:user)
    taggee_user = FactoryGirl.create(:user, screen_name: "taggee", email: "taggee@example.com")
    tagger = FactoryGirl.create(:player, user: tagger_user, game: game)
    taggee = FactoryGirl.create(:player, user: taggee_user, game: game, human_code: "taggee")

    organization_events_count = organization.events.count
    game_events_count = game.events.count
    tagger_user_events_count = tagger_user.events.count
    taggee_user_events_count = taggee_user.events.count
    tagger_events_count = tagger.events.count
    taggee_events_count = taggee.events.count

    tag = FactoryGirl.create(:tag, tagger: tagger, taggee: taggee)

    expect(organization.events.count).to eq(organization_events_count + 1)
    expect(game.events.count).to eq(game_events_count + 1)
    expect(tagger_user.events.count).to eq(tagger_user_events_count + 1)
    expect(taggee_user.events.count).to eq(taggee_user_events_count + 1)
    expect(tagger.events.count).to eq(tagger_events_count + 1)
    expect(taggee.events.count).to eq(taggee_events_count + 1)
    expect(tag.event).not_to eq(nil)
  end

end