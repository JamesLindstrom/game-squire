FactoryBot.define do
  factory :game_space do
    name { Faker::Name.name }
    user { create(:user) }
  end
end
