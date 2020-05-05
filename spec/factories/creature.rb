FactoryBot.define do
  factory :creature do
    name { Faker::Name.name }
    variety { 'player' }
    initiative_bonus { Faker::Number.between(from: -1, to: 5) }
    user { create(:user) }

    trait :player do
      variety { 'player' }
      armor_class { Faker::Number.between(from: 8, to: 22) }
      advantage { false }
      initiative_bonus { Faker::Number.between(from: -1, to: 5) }
      initiative_value { nil }
    end

    trait :npc do
      variety { 'npc' }
      armor_class { Faker::Number.between(from: 8, to: 22) }
      advantage { false }
      initiative_bonus { Faker::Number.between(from: -1, to: 5) }
      initiative_value { nil }
    end

    trait :event do
      variety { 'event' }
      initiative_bonus { nil }
      initiative_value { Faker::Number.between(from: 0, to: 25) }
    end
  end
end
