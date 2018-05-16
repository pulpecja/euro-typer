FactoryBot.define do
  factory :group do
    name "Kraków"
    token "MyString"

    before(:create) do |g|
      g.owner_id = create(:user).id
    end
  end
end
