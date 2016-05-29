require 'rails_helper'

RSpec.describe "matches/edit", type: :view do
  before(:each) do
    @match = assign(:match, Match.create!(
      :first_team_id => 1,
      :second_team_id => 1
    ))
  end

  it "renders the edit match form" do
    render

    assert_select "form[action=?][method=?]", match_path(@match), "post" do

      assert_select "input#match_first_team_id[name=?]", "match[first_team_id]"

      assert_select "input#match_second_team_id[name=?]", "match[second_team_id]"
    end
  end
end
