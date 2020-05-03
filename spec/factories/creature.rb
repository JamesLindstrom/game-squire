FactoryBot.define do
  factory :creature do
    name { Faker::Name.name }
    type { 'Player' }
    armor_class { Faker::Number.between(from: 8, to: 22) }
    initiative_bonus { Faker::Number.between(from: -1, to: 5) }
    advantage { false }
    user { create(:user) }
  end
end
