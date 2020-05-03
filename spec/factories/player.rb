FactoryBot.define do
  factory :player do
    name { Faker::Name.name }
    armor_class { Faker::Number.between(from: 8, to: 22) }
    initiative_bonus { Faker::Number.between(from: -1, to: 5) }
    advantage { false }
    user { create(:user) }
  end
end
