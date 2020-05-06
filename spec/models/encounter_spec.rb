# == Schema Information
#
# Table name: encounters
#
#  id               :integer          not null, primary key
#  name             :string           not null
#  history          :json
#  game_space_id    :integer
#  initiative_order :json
#

require "rails_helper"

RSpec.describe Encounter, type: :model do
  it 'has a valid factory' do
    expect(create(:encounter)).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:game_space) }
    it { should have_and_belong_to_many(:creatures) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'methods' do
    describe 'user' do
      it 'should return the user for the game_space the encounter belongs to' do
        user = create(:user)
        game_space = create(:game_space, user: user)
        encounter = create(:encounter, game_space: game_space)

        expect(encounter.user.id).to eq user.id
      end
    end

    describe 'roll_initiative' do
      it 'should create an array of creatures sorted by their initiative rolls' do
        user = create(:user)
        player = create(:creature, :player)
        npc = create(:creature, :npc)
        event = create(:creature, :event)
        game_space = create(:game_space, user: user)
        encounter = create(:encounter, game_space: game_space)
        encounter.creatures = [player, npc, event]

        encounter.roll_initiative
        expect(encounter.initiative_order[0]['result']).to be >= encounter.initiative_order[1]['result']
        expect(encounter.initiative_order[1]['result']).to be >= encounter.initiative_order[2]['result']
      end
    end

    describe 'next_turn' do
      before(:each) do
        @user = create(:user)
        @player = create(:creature, :player)
        @npc = create(:creature, :npc)
        @event = create(:creature, :event)
        @game_space = create(:game_space, user: @user)
        @encounter = create(:encounter, game_space: @game_space)
        @encounter.creatures = [@player, @npc, @event]
        @encounter.roll_initiative
      end

      context 'when no turns have been taken' do
        it 'should add the first creature in initiative order to history' do
          expect(@encounter.history).to be_nil
          @encounter.next_turn
          expect(@encounter.history.last['creature_id']).to eq @encounter.initiative_order.first['creature_id']
        end
      end

      context 'when some turns have been taken' do
        it 'should add the next creature in initiative order to history' do
          @encounter.next_turn
          expect(@encounter.history).to_not be_nil
          @encounter.next_turn
          expect(@encounter.history.last['creature_id']).to eq @encounter.initiative_order[1]['creature_id']
        end
      end

      context 'when every creature has gone once' do
        it 'should start over from the begining of initiative order' do
          length_of_init_order = @encounter.initiative_order.size
          length_of_init_order.times { @encounter.next_turn }
          expect(@encounter.history.size).to eq @encounter.initiative_order.size
          @encounter.next_turn
          expect(@encounter.history.last['creature_id']).to eq @encounter.initiative_order.first['creature_id']
        end
      end
    end
  end
end
