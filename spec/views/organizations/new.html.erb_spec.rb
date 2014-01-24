require 'spec_helper'

describe "organizations/new" do
  before(:each) do
    assign(:organization, stub_model(Organization,
      :name => "MyString",
      :slug => "MyString",
      :location => "MyString",
      :default_timezone => "MyString",
      :description => "MyString",
      :user => ""
    ).as_new_record)
  end

  it "renders new organization form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", organizations_path, "post" do
      assert_select "input#organization_name[name=?]", "organization[name]"
      assert_select "input#organization_slug[name=?]", "organization[slug]"
      assert_select "input#organization_location[name=?]", "organization[location]"
      assert_select "input#organization_default_timezone[name=?]", "organization[default_timezone]"
      assert_select "input#organization_description[name=?]", "organization[description]"
      assert_select "input#organization_user[name=?]", "organization[user]"
    end
  end
end
