require 'rails_helper'

RSpec.describe "competitions/index", type: :view do
  before(:each) do
    assign(:competitions, [
      Competition.create!(
        :name => "Name",
        :year => 1,
        :place => "Place"
      ),
      Competition.create!(
        :name => "Name",
        :year => 1,
        :place => "Place"
      )
    ])
  end

  it "renders a list of competitions" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Place".to_s, :count => 2
  end
end
