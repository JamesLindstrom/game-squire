FactoryBot.define do
  factory :encounter do
    name { Faker::Name.name }
    game_space { create(:game_space) }
  end
end
