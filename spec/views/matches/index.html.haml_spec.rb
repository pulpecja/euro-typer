require 'rails_helper'

RSpec.describe "matches/index", type: :view do
  before(:each) do
    assign(:matches, [
      Match.create!(
        :first_team_id => 1,
        :second_team_id => 2
      ),
      Match.create!(
        :first_team_id => 1,
        :second_team_id => 2
      )
    ])
  end

  it "renders a list of matches" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
