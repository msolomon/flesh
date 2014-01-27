require "spec_helper"

describe Api::GamesController do
  describe "routing" do

    it "routes to #index" do
      get("/api/games").should route_to("api/games#index")
    end

    it "routes to #show" do
      get("/api/games/1").should route_to("api/games#show", :id => "1")
    end

  end
end
