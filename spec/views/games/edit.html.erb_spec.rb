require 'spec_helper'

describe "games/edit" do
  before(:each) do
    @game = assign(:game, stub_model(Game,
      :name => "MyString",
      :slug => "MyString",
      :organization => nil,
      :timezone => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit game form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", game_path(@game), "post" do
      assert_select "input#game_name[name=?]", "game[name]"
      assert_select "input#game_slug[name=?]", "game[slug]"
      assert_select "input#game_organization[name=?]", "game[organization]"
      assert_select "input#game_timezone[name=?]", "game[timezone]"
      assert_select "input#game_description[name=?]", "game[description]"
    end
  end
end
