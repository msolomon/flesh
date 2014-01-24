require 'spec_helper'

describe "organizations/index" do
  before(:each) do
    assign(:organizations, [
      stub_model(Organization,
        :name => "Name",
        :slug => "Slug",
        :location => "Location",
        :default_timezone => "Default Timezone",
        :description => "Description",
        :user => ""
      ),
      stub_model(Organization,
        :name => "Name",
        :slug => "Slug",
        :location => "Location",
        :default_timezone => "Default Timezone",
        :description => "Description",
        :user => ""
      )
    ])
  end

  it "renders a list of organizations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Slug".to_s, :count => 2
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => "Default Timezone".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
