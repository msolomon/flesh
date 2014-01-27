require "spec_helper"

describe Api::OrganizationsController do
  describe "routing" do

    it "routes to #index" do
      get("/api/organizations").should route_to("api/organizations#index")
    end

    it "routes to #show" do
      get("/api/organizations/1").should route_to("api/organizations#show", :id => "1")
    end

  end
end
