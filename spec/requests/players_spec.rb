require 'spec_helper'

describe "Players" do
  describe "GET players" do
    it "gets players.json" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get api_players_path, format: :json
      response.status.should be(200)
    end
  end
end
