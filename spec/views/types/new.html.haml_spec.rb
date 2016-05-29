require 'rails_helper'

RSpec.describe "types/new", type: :view do
  before(:each) do
    assign(:type, Type.new(
      :user_id => 1,
      :match_id => 1,
      :first_score => "",
      :second_score => ""
    ))
  end

  it "renders new type form" do
    render

    assert_select "form[action=?][method=?]", types_path, "post" do

      assert_select "input#type_user_id[name=?]", "type[user_id]"

      assert_select "input#type_match_id[name=?]", "type[match_id]"

      assert_select "input#type_first_score[name=?]", "type[first_score]"

      assert_select "input#type_second_score[name=?]", "type[second_score]"
    end
  end
end
