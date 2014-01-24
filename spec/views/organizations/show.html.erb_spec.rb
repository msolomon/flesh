require 'spec_helper'

describe "organizations/show" do
  before(:each) do
    @organization = assign(:organization, stub_model(Organization,
      :name => "Name",
      :slug => "Slug",
      :location => "Location",
      :default_timezone => "Default Timezone",
      :description => "Description",
      :user => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Slug/)
    rendered.should match(/Location/)
    rendered.should match(/Default Timezone/)
    rendered.should match(/Description/)
    rendered.should match(//)
  end
end
