require 'rails_helper'

RSpec.describe "competitions/new", type: :view do
  before(:each) do
    assign(:competition, Competition.new(
      :name => "MyString",
      :year => 1,
      :place => "MyString"
    ))
  end

  it "renders new competition form" do
    render

    assert_select "form[action=?][method=?]", competitions_path, "post" do

      assert_select "input#competition_name[name=?]", "competition[name]"

      assert_select "input#competition_year[name=?]", "competition[year]"

      assert_select "input#competition_place[name=?]", "competition[place]"
    end
  end
end
