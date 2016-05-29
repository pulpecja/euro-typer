require 'rails_helper'

RSpec.describe "matches/new", type: :view do
  before(:each) do
    assign(:match, Match.new(
      :first_team_id => 1,
      :second_team_id => 1
    ))
  end

  it "renders new match form" do
    render

    assert_select "form[action=?][method=?]", matches_path, "post" do

      assert_select "input#match_first_team_id[name=?]", "match[first_team_id]"

      assert_select "input#match_second_team_id[name=?]", "match[second_team_id]"
    end
  end
end
