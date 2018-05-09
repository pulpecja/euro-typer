FactoryBot.define do
  factory :group do
    name "MyString"
    token "MyString"

    before(:create) do |g|
      g.owner_id = create(:user).id
    end
  end
end
