require 'rails_helper'

RSpec.describe "competitions/edit", type: :view do
  before(:each) do
    @competition = assign(:competition, Competition.create!(
      :name => "MyString",
      :year => 1,
      :place => "MyString"
    ))
  end

  it "renders the edit competition form" do
    render

    assert_select "form[action=?][method=?]", competition_path(@competition), "post" do

      assert_select "input#competition_name[name=?]", "competition[name]"

      assert_select "input#competition_year[name=?]", "competition[year]"

      assert_select "input#competition_place[name=?]", "competition[place]"
    end
  end
end
