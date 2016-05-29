require 'rails_helper'

RSpec.describe "types/index", type: :view do
  before(:each) do
    assign(:types, [
      Type.create!(
        :user_id => 1,
        :match_id => 2,
        :first_score => "",
        :second_score => ""
      ),
      Type.create!(
        :user_id => 1,
        :match_id => 2,
        :first_score => "",
        :second_score => ""
      )
    ])
  end

  it "renders a list of types" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
