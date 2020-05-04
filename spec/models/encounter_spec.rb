# == Schema Information
#
# Table name: encounters
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  history       :json
#  game_space_id :integer
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
  end
end
