# == Schema Information
#
# Table name: creatures
#
#  id               :integer          not null, primary key
#  name             :string           not null
#  variety          :integer          not null
#  armor_class      :integer
#  initiative_bonus :integer
#  advantage        :boolean
#  initiative_value :integer
#  user_id          :integer
#

require "rails_helper"

RSpec.describe Creature, type: :model do
  it 'has a valid factory' do
    expect(create(:creature)).to be_valid
    expect(create(:creature, :player)).to be_valid
    expect(create(:creature, :npc)).to be_valid
    expect(create(:creature, :event)).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_and_belong_to_many(:encounters) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:variety) }

    it 'should validate the presence of initiative bonus when a player' do
      creature = Creature.new(name: Faker::Name.name, variety: 'player',
                              user_id: create(:user).id)
      expect(creature).to_not be_valid

      creature.initiative_bonus = 3
      expect(creature).to be_valid
    end

    it 'should validate the presence of initiative bonus when an npc' do
      creature = Creature.new(name: Faker::Name.name, variety: 'npc',
                              user_id: create(:user).id)
      expect(creature).to_not be_valid

      creature.initiative_bonus = 3
      expect(creature).to be_valid
    end

    it 'should validate the presence of initiative value when an event' do
      creature = Creature.new(name: Faker::Name.name, variety: 'event',
                              user_id: create(:user).id)
      expect(creature).to_not be_valid

      creature.initiative_value = 3
      expect(creature).to be_valid
    end

    it 'should not be able to destroy a creature that is part of an active encounter' do
      creature = create(:creature)
      game_space = create(:game_space, user_id: creature.user_id)
      encounter = create(:encounter, game_space_id: game_space.id)
      encounter.creatures << creature

      encounter.roll_initiative
      encounter.next_turn
      encounter.game_space.update(current_encounter_id: encounter.id)

      expect(creature.destroy).to be false
      expect(creature).to be_persisted

      encounter.game_space.update(current_encounter_id: nil)

      creature.reload.destroy
      expect(creature).to_not be_persisted
    end
  end
end
