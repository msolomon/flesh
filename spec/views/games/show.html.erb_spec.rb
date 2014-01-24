require 'spec_helper'

describe "games/show" do
  before(:each) do
    @game = assign(:game, stub_model(Game,
      :name => "Name",
      :slug => "Slug",
      :organization => nil,
      :timezone => "Timezone",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Slug/)
    rendered.should match(//)
    rendered.should match(/Timezone/)
    rendered.should match(/Description/)
  end
end
