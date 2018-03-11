require 'rails_helper'

RSpec.describe "competitions/show", type: :view do
  before(:each) do
    @competition = assign(:competition, Competition.create!(
      :name => "Name",
      :year => 1,
      :place => "Place"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Place/)
  end
end
