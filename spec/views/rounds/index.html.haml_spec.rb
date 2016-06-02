require 'rails_helper'

RSpec.describe "rounds/index", type: :view do
  before(:each) do
    assign(:rounds, [
      Round.create!(
        :name => "Name"
      ),
      Round.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of rounds" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
