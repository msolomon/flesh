require 'spec_helper'

describe "games/new" do
  before(:each) do
    assign(:game, stub_model(Game,
      :name => "MyString",
      :slug => "MyString",
      :organization => nil,
      :timezone => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new game form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", games_path, "post" do
      assert_select "input#game_name[name=?]", "game[name]"
      assert_select "input#game_slug[name=?]", "game[slug]"
      assert_select "input#game_organization[name=?]", "game[organization]"
      assert_select "input#game_timezone[name=?]", "game[timezone]"
      assert_select "input#game_description[name=?]", "game[description]"
    end
  end
end
