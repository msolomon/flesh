require 'spec_helper'

describe "games/index" do
  before(:each) do
    assign(:games, [
      stub_model(Game,
        :name => "Name",
        :slug => "Slug",
        :organization => nil,
        :timezone => "Timezone",
        :description => "Description"
      ),
      stub_model(Game,
        :name => "Name",
        :slug => "Slug",
        :organization => nil,
        :timezone => "Timezone",
        :description => "Description"
      )
    ])
  end

  it "renders a list of games" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Slug".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Timezone".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
