require 'spec_helper'

describe "Games" do
  describe "GET games" do
    it "GET games.json" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get api_games_path, format: :json
      response.status.should be(200)
    end
  end
end
