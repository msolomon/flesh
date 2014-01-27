require 'spec_helper'

describe "Organizations" do
  describe "GET organizations" do
    it "GET organizations.json" do
      get api_organizations_path, format: :json
      response.status.should be(200)
    end
  end
end
