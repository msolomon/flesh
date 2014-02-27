require 'spec_helper'

describe "Player model" do
  it 'records join game events on create' do
    user = FactoryGirl.create(:user)
    expect(user.events.count).to eq(1)
  end

end