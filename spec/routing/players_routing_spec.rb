require "spec_helper"

describe Api::PlayersController do
  describe "routing" do

    it "routes to #index" do
      get("/api/players").should route_to("api/players#index")
    end

    it "routes to #new" do
      get("/api/players/new").should route_to("api/players#new")
    end

    it "routes to #show" do
      get("/api/players/1").should route_to("api/players#show", :id => "1")
    end

    it "routes to #edit" do
      get("/api/players/1/edit").should route_to("api/players#edit", :id => "1")
    end

    it "routes to #create" do
      post("/api/players").should route_to("api/players#create")
    end

    it "routes to #update" do
      put("/api/players/1").should route_to("api/players#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/api/players/1").should route_to("api/players#destroy", :id => "1")
    end

  end
end
