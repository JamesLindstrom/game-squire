FactoryBot.define do
  factory :event do
    name { Faker::Name.name }
    armor_class { Faker::Number.between(from: 8, to: 22) }
    initiative_value { 20 }
    advantage { false }
    user { create(:user) }
  end
end
