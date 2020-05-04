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
end
