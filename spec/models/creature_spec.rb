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
  end
end
